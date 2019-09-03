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

class MakePostVC: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var donationType = ["Bloods","Money","Clothes","Food","Others"]
    var imagePicker:UIImagePickerController!
    var effect:UIVisualEffect!
    var type:String?
    var pdfID:String?
    var PDF_ID:String?
    var flag:Bool = false
    
    @IBOutlet weak var type_Picker: UIPickerView!
    @IBOutlet weak var selectType: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet var mapView: CustomView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var VisualEffect: UIVisualEffectView!
    
    @IBOutlet var progView: CustomView!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var prog: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func buSelectPicture(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            postImage.image = image
            self.showAlertsuccess(title: "Image Added Successfully")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func buSelectType(_ sender: Any) {
        Show_map_View()
    }
    
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
    
    func Hide_Progress_View()
    {
        UIView.animate(withDuration: 0.3) {
            self.progView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.progView.alpha = 0
            self.VisualEffect.effect = nil
            self.progView.removeFromSuperview()
            self.VisualEffect.isHidden = true
        }
    }
    
    func Show_Progress_View(){
        self.VisualEffect.isHidden = false
        self.view.addSubview(progView)
        progView.center = self.view.center
        progView.transform = CGAffineTransform.init(scaleX:  1.3, y: 1.3)
        progView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.VisualEffect.effect = self.effect
            self.progView.alpha = 1
            self.progView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func buAddFile(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [ kUTTypePDF as String ], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func buPost(_ sender: Any) {
        
        guard let postImage = postImage.image else{
            self.showAlertWiring(title: "Image must be selected")
            return
        }
        
        guard let postText = postText.text, postText != "" else{
            self.showAlertWiring(title: "Please enter the text")
            return
        }
        
        guard let donationType = type, donationType != "" else{
            self.showAlertWiring(title: "Please select donation type")
            return
        }
        
        if flag{
            self.PDF_ID = self.pdfID!
        }else{
            self.PDF_ID = "Empty"
        }
        
        guard let id = UserDefaults.standard.string(forKey: KEY_UID) else{return}
        
        
        if let img = postImage.jpegData(compressionQuality: 0.2){
            let imgId = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.db.REF_POST_IMAGE.child(imgId).putData(img, metadata: metaData, completion: { (metadata,error) in
                if error != nil{
                    self.showAlertWiring(title: "Unable to upload image")
                }else{
                    DataService.db.REF_POST_IMAGE.child(imgId).downloadURL(completion: { (url,error) in
                        
                        self.uploadToFirebase(imageID: url!.absoluteString, userID: id, donationType: donationType, pdfUrl: self.PDF_ID!, postText: postText, completeion: {
                            self.Hide_Progress_View()
                            let home = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                            self.present(home, animated: true, completion: nil)
                            self.showAlertsuccess(title: "Post Sent Successfully")
                        })
                    })
                }
            }).observe(.progress, handler: { (snapshot) in
                self.Show_Progress_View()
                let num = snapshot.progress!.fractionCompleted
                self.prog.progress = Float(num)
                let y = Double(round(100*num)/100)
                self.lblProgress.text = "\(Int(y*100))%"
            })
        }
        
    }
    
    func uploadToFirebase(imageID: String, userID: String,donationType: String,pdfUrl:String , postText: String, completeion: () -> ()){
        let post: Dictionary<String,Any> = ["Id": userID,"donationType": donationType, "Text": postText,"ImageUrl": imageID,"PDFURL": pdfUrl,"Likes":0]
        DataService.db.REF_POST.childByAutoId().setValue(post)
        completeion()
    }
    
    
    @IBAction func buMenu(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}

extension MakePostVC:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return donationType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return donationType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectType.setTitle(donationType[row], for: .normal)
        self.type = donationType[row]
        Hide_Map_View()
    }
}

extension MakePostVC: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        do{
            let data = try Data.init(contentsOf: urls.first!)
            let fileId = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "application/pdf"
            
            DataService.db.REF_POST_PDF.child(fileId).putData(data, metadata: metaData, completion: { (metadata,error) in
                print("File Uploaded Successfully")
                if error != nil{
                    self.showAlertWiring(title: "Unable to upload PDF")
                }else{
                    DataService.db.REF_POST_PDF.child(fileId).downloadURL(completion: { (url,error) in
                        self.pdfID = url!.absoluteString
                        self.flag = true
                    })
                }
                
            })
        }catch{
            
        }
    }}
