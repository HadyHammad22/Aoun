//
//  ChatVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/21/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class ChatVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var postOwnerID:String? {
        didSet{
            DataService.db.getUserWithId(id: postOwnerID!, completion: { (user) in
                self.navigationItem.title = user!.name
            })
        } 
    }
    
    var messages = [Message]()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet var selectImage: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 58, right: 0)
        observeMessages()
        setupKeyboardObserves()
        tableView.keyboardDismissMode = .interactive
        selectImage.addTarget(self, action: #selector(handleSendImage))
    }
    
    @objc func handleSendImage(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage,kUTTypeMovie] as [String]
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            //we selected video
            //handleVideoSelectedForURL(videoUrl)
        }else{
            //we selected image
            handleImageSelectedForInfo(info: info)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func handleImageSelectedForInfo(info: [UIImagePickerController.InfoKey:Any]){
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            uploadImageToFirebase(image: image, completeion: { (imageUrl) in
                self.sendMessagesWithImage(imageUrl: imageUrl, image: image)
            })
        }else{
            print("JESS: A Valid Image Wasn't Selected")
        }
        
    }
    
    func uploadImageToFirebase(image: UIImage, completeion: @escaping (_ imageUrl: String)->()){
        if let imgData = image.jpegData(compressionQuality: 0.2){
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.db.REF_MESSAGES_IMAGES.child(imgUid).putData(imgData, metadata: metaData, completion: { (metadata,error) in
                if error != nil{
                    print("JESS: unable To Upload Image To Firebase Storage")
                    return
                }else{
                    print("JESS: Upload Image To Firebase Storage Successfully")
                    DataService.db.REF_MESSAGES_IMAGES.child(imgUid).downloadURL(completion: { (url, error) in
                        if let imageUrl = url?.absoluteString{
                            completeion(imageUrl)
                        }
                    })
                }
            })
            
        }
    }
    
    private func sendMessagesWithImage(imageUrl: String, image: UIImage){
        let dict = [ "imageUrl": imageUrl, "imageWidth": image.size.width, "imageHieght": image.size.height] as [String : Any]
        DataService.db.sendMessgaeToFirebase(toId: postOwnerID!, properties: dict, completeion: { result in
            if result{
                print("Messgae Sent Successfully")
            }
        })
    }
    
    func setupKeyboardObserves(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func handleKeyboardDidShow(){
        if messages.count > 0{
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    func observeMessages(){
        guard let id = Auth.auth().currentUser?.uid, let toId = postOwnerID else{return}
        DataService.db.REF_USER_MESSAGES.child(id).child(toId).observe(.childAdded, with: { (snapshot) in
            DataService.db.REF_MESSAGES.child(snapshot.key).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? Dictionary<String,Any>{
                    let msg = Message(msg: dict)
                    self.messages.append(msg)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

                    }
                }
            })
        })
    }
    
    func removeNotification(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        DataService.db.NOTIFICATION.child(uid).child(postOwnerID!).removeValue(completionBlock: { (err,ref) in
            if err == nil{
                print("notification removed successfully...")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = self.messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! ChatMessageCell
        if msg.fromId == Auth.auth().currentUser?.uid{
            cell.configureCell(message: msg, type: .outgoing)
        }else{
            cell.configureCell(message: msg, type: .incoming)
        }
        
        return cell
    }
    
    @IBAction func buSend(_ sender: Any) {
        guard let msgText = messageTextField.text else {
            return
        }
        
        guard let ownerID = postOwnerID else {
            return
        }
        DataService.db.sendMessgaeToFirebase(toId: ownerID, properties: ["text": msgText] ,completeion: { result in
            if result{
                messageTextField.text = nil
                print("Messgae Send Successfully")
            }
        })
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.removeNotification()
        })
    }
}
