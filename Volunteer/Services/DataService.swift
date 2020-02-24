//
//  DataService.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/27/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService: BaseViewController {
    static let db = DataService()
    //DB_References
    let _REF_BASE = DB_BASE
    let _REF_USERS = DB_BASE.child("users")
    let _REF_POST = DB_BASE.child("post")
    let _REF_MESSAGES = DB_BASE.child("messages")
    let _REF_USER_MESSAGES = DB_BASE.child("user-messages")
    let _NOTIFICATION = DB_BASE.child("notification")
    
    //Storage_References
    let _REF_POST_IMAGE = STORAGE_BASE.child("post-pics")
    let _REF_MESSAGES_IMAGES = STORAGE_BASE.child("messages-images")
    let _REF_POST_PDF = STORAGE_BASE.child("post-pdf")
    
    var REF_BASE:DatabaseReference{
        return _REF_BASE
    }
    
    var REF_POST:DatabaseReference{
        return _REF_POST
    }
    
    var REF_USERS:DatabaseReference{
        return _REF_USERS
    }
    
    var REF_MESSAGES:DatabaseReference{
        return _REF_MESSAGES
    }
    
    var REF_USER_MESSAGES:DatabaseReference{
        return _REF_USER_MESSAGES
    }
    
    var REF_CURRENT_USERS:DatabaseReference{
        let uid = UserDefaults.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var NOTIFICATION:DatabaseReference{
        return _NOTIFICATION
    }
    
    var REF_POST_IMAGE: StorageReference{
        return _REF_POST_IMAGE
    }
    
    var REF_MESSAGES_IMAGES: StorageReference{
        return _REF_MESSAGES_IMAGES
    }
    
    var REF_POST_PDF: StorageReference{
        return _REF_POST_PDF
    }
    
    func login(email: String, password: String, onSuccess: @escaping (_ user: User) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        self.showLoadingIndicator()
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            self.hideLoadingIndicator()
            if error == nil{
                guard let user = result?.user else{return}
                DataService.db.REF_USERS.child(user.uid).updateChildValues(["password": password])
                onSuccess(user)
            }else{
                if let errorMessage = error?.localizedDescription {
                    onError(errorMessage)
                }
            }
        })
    }
    
    func signUp(userData: [String:String], onSuccess: @escaping (_ user: User) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        guard let email = userData["email"], let pwd = userData["password"] else{return}
        self.showLoadingIndicator()
        Auth.auth().createUser(withEmail: email, password: pwd, completion: { (result, error) in
            self.hideLoadingIndicator()
            if error == nil{
                guard let user = result?.user else{return}
                self.REF_USERS.child(user.uid).updateChildValues(userData)
                onSuccess(user)
            }else{
                if let errorMessage = error?.localizedDescription {
                    onError(errorMessage)
                }
            }
            
        })
    }
    
    func sendMessgaeToFirebase(toId: String, properties: [String:Any], completeion: (_ result:Bool)->()) {
        guard let fromId = Auth.auth().currentUser?.uid else{return}
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let childRef = REF_MESSAGES.childByAutoId()
        var dict:[String : Any] = ["toId": toId, "fromId": fromId,"timeStamp": timestamp]
        
        properties.forEach({dict[$0] = $1})
        
        childRef.updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
            
            let receiptionUserMessagesRef = self.REF_USER_MESSAGES.child(toId).child(fromId)
            let msgID = childRef.key
            receiptionUserMessagesRef.updateChildValues([msgID!: true])
            
            let userMessagesRef = self.REF_USER_MESSAGES.child(fromId).child(toId)
            userMessagesRef.updateChildValues([msgID!: true])
        })
        completeion(true)
    }
    
    func getUserWithId(id: String, completion: @escaping (_ user: AppUser?)->()) {
        REF_USERS.child(id).observe(.value, with: { snapshot in
            guard let dict = snapshot.value as? [String:Any] else{return}
            do{
                let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                let user = try JSONDecoder().decode(AppUser.self, from: data)
                completion(user)
            }catch let err{
                print("Error In Decode Data \(err.localizedDescription)")
            }
        })
    }
    
    func getPosts(onSuccess: @escaping (_ posts: [Post]?) -> Void) {
        var posts = [Post]()
        self.showLoadingIndicator()
        REF_POST.observeSingleEvent(of: .value, with: { (snapshot) in
            self.hideLoadingIndicator()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let postDict = snap.value as? Dictionary<String,AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, post: postDict)
                        posts.append(post)
                    }
                }
            }
            posts = posts.sorted(by: { $0.likes! > $1.likes!})
            onSuccess(posts)
        })
    }
    
    func getMessages(onSuccess: @escaping (_ posts: [String:Any]?) -> Void) {
        var messagesDictionary = [String:Any]()
        guard let uid = Auth.auth().currentUser?.uid else{return}
        self.showLoadingIndicator()
        DataService.db.REF_USER_MESSAGES.child(uid).observe(.childAdded, with: { (snapshot)in
            DataService.db.REF_USER_MESSAGES.child(uid).child(snapshot.key).observe(.childAdded, with: { (snapshot)in
                DataService.db.REF_MESSAGES.child(snapshot.key).observe(.value, with: { (snapshot)in
                    self.hideLoadingIndicator()
                    if let dict = snapshot.value as? Dictionary<String,Any>{
                        let msg = Message(msg: dict)
                        if let id = msg.partnerID(){
                            messagesDictionary[id] = msg
                        }
                        onSuccess(messagesDictionary)
                    }
                })
            })
        })
    }
    
    func uploadPDF(url: URL,  onSuccess: @escaping (_ url: String) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        do{
            let data = try Data.init(contentsOf: url)
            let fileId = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "application/pdf"
            DataService.db.REF_POST_PDF.child(fileId).putData(data, metadata: metaData, completion: { (metadata,error) in
                if error != nil{
                    onError(error!.localizedDescription)
                }else{
                    DataService.db.REF_POST_PDF.child(fileId).downloadURL(completion: { (url,error) in
                        guard let url = url?.absoluteString else{return}
                        onSuccess(url)
                    })
                }
            })
        }catch let error{
            onError(error.localizedDescription)
        }
    }
    
    func resetPassword(email: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void ){
        self.showLoadingIndicator()
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            self.hideLoadingIndicator()
            if error == nil{
                onSuccess()
            }else{
                if let errorMessage = error?.localizedDescription {
                    onError(errorMessage)
                }
            }
        })
    }
    
    func updateProfile(userData: [String:Any], onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void ){
        guard let uid = UserDefaults.standard.string(forKey: KEY_UID) else {return}
        self.showLoadingIndicator()
        DataService.db.REF_USERS.child(uid).updateChildValues(userData, withCompletionBlock: { (error, result) in
            self.hideLoadingIndicator()
            if error == nil{
                onSuccess()
            }else{
                if let errorMessage = error?.localizedDescription {
                    onError(errorMessage)
                }
            }
        })
    }
    
    func updatePassword(password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void ){
        guard let uid = UserDefaults.standard.string(forKey: KEY_UID) else {return}
        self.showLoadingIndicator()
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            self.hideLoadingIndicator()
            if error == nil{
                DataService.db.REF_USERS.child(uid).updateChildValues(["password": password])
                onSuccess()
            }else{
                if let errorMessage = error?.localizedDescription {
                    onError(errorMessage)
                }
            }
        })
    }
    
}
