//
//  MakePostVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/31/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class MakePostVC: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK :- Outlets
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var selectPictureBtn: UIButton!
    @IBOutlet weak var type_Picker: UIPickerView!
    @IBOutlet weak var selectTypeBtn: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var addFileBtn: UIButton!
    @IBOutlet var mapView: UIView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var VisualEffect: UIVisualEffectView!
    @IBOutlet weak var postBtn: UIButton!
    
    // MARK :- Instance Variables
    var imagePicker:UIImagePickerController!
    var effect:UIVisualEffect!
    var type:DonationType?
    var pdfURL:URL?
    var donationTypesArray:[DonationType]?
    
    // MARK :- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        DataService.db.getDonationTypes(onSuccess: { arr in
            self.donationTypesArray = arr
        })
    }
    
    // MARK :- SetupUI
    func setupComponents() {
        backView.addCornerRadius(8)
        backView.addNormalShadow()
        mapView.addCornerRadius(8)
        mapView.addNormalShadow()
        selectPictureBtn.addBtnCornerRadius(5)
        selectPictureBtn.addBtnNormalShadow()
        selectTypeBtn.addBtnCornerRadius(5)
        selectTypeBtn.addBtnNormalShadow()
        addFileBtn.addBtnCornerRadius(5)
        addFileBtn.addBtnNormalShadow()
        postBtn.addBtnCornerRadius(8)
        postBtn.addBtnNormalShadow()
        postText.addCornerRadius(5)
        self.type_Picker.delegate = self
        self.type_Picker.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        VisualEffect.isHidden = true
        effect = VisualEffect.effect
        VisualEffect.effect = nil
    }
    
    // MARK :- Image Picker Delegate
    @IBAction func buSelectPicture(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            postImage.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // MARK :- Select Donation Type Action
    @IBAction func buSelectType(_ sender: Any) {
        Show_map_View()
    }
    
    @IBAction func buAddFile(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [ kUTTypePDF as String ], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func buPost(_ sender: Any) {
        guard let postImage = postImage.image else{
            self.showAlertWiring(title: "Image must be selected".localized)
            return
        }
        
        guard let postText = postText.text, postText != "" else{
            self.showAlertWiring(title: "Please enter the text".localized)
            return
        }
        
        guard let donationType = type else{
            self.showAlertWiring(title: "Please select donation type".localized)
            return
        }
        
        if let img = postImage.jpegData(compressionQuality: 0.2) {
            let imgId = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            self.showLoadingIndicator()
            DataService.db.REF_POST_IMAGE.child(imgId).putData(img, metadata: metaData, completion: { (metadata,error) in
                if error != nil{
                    self.hideLoadingIndicator()
                    self.showAlertWiring(title: "Faild to upload post".localized)
                }else{
                    DataService.db.REF_POST_IMAGE.child(imgId).downloadURL(completion: { (url,error) in
                        guard let imgURL = url?.absoluteString else{
                            self.hideLoadingIndicator()
                            return}
                        self.uploadWithPDF(imageURL: imgURL, donationType: donationType, postText: postText)
                    })
                }
            })
        }
    }
    
    func uploadWithPDF(imageURL: String, donationType: DonationType, postText: String) {
        guard let id = UserDefaults.standard.string(forKey: KEY_UID) else{
            self.hideLoadingIndicator()
            return}
        if let pdfURL = self.pdfURL {
            DataService.db.uploadPDF(url: pdfURL, onSuccess: { pdfURL in
                let post: [String:Any] = ["userID": id,
                                          "donationType": ["id": donationType.id!, "type": donationType.type!, "arabicType": donationType.arabicType!],
                                          "text": postText,
                                          "imageUrl": imageURL,
                                          "pdfURL": pdfURL,
                                          "timestamp": [".sv": "timestamp"],
                                          "likes": 0]
                DataService.db.REF_POST.childByAutoId().setValue(post)
                self.successPostUpload()
            }, onError: { errorMessage in
                self.hideLoadingIndicator()
                self.showAlertError(title: errorMessage)
            })
        }else{
            let post: [String:Any] = ["userID": id,
                                      "donationType": ["id": donationType.id!, "type": donationType.type!, "arabicType": donationType.arabicType!],
                                      "text": postText,
                                      "imageUrl": imageURL,
                                      "timestamp": [".sv":"timestamp"],
                                      "likes":0]
            DataService.db.REF_POST.childByAutoId().setValue(post)
            self.successPostUpload()
        }
    }
    
    func successPostUpload(){
        self.hideLoadingIndicator()
        self.showAlertsuccess(title: "Post sent success".localized)
        let nav = UINavigationController(rootViewController: MainTabBar.instance())
        self.present(nav, animated: true, completion: nil)
    }
    
    // MARK :- Pop Up Views
    func Hide_Map_View()
    {
        UIView.animate(withDuration: 0.3) {
            self.mapView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.mapView.alpha = 0
            self.VisualEffect.effect = nil
            self.mapView.removeFromSuperview()
            self.VisualEffect.isHidden = true
        }
    }
    
    func Show_map_View(){
        self.VisualEffect.isHidden = false
        self.view.addSubview(mapView)
        mapView.center = self.view.center
        mapView.transform = CGAffineTransform.init(scaleX:  1.3, y: 1.3)
        mapView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.VisualEffect.effect = self.effect
            self.mapView.alpha = 1
            self.mapView.transform = CGAffineTransform.identity
        }
    }
    
}

extension MakePostVC:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let count = donationTypesArray?.count else{return 0}
        return count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let arabicType = donationTypesArray?[row].arabicType, let type = donationTypesArray?[row].type else{return ""}
        if Language.currentLanguage == .arabic{
            return arabicType
        }else{
            return type
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let arabicType = donationTypesArray?[row].arabicType, let type = donationTypesArray?[row].type else{return}
        if Language.currentLanguage == .arabic{
            selectTypeBtn.setTitle(arabicType, for: .normal)
            self.type = donationTypesArray?[row]
        }else{
            selectTypeBtn.setTitle(type, for: .normal)
            self.type = donationTypesArray?[row]
        }
        Hide_Map_View()
    }
}

extension MakePostVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.pdfURL = urls.first
    }
}
