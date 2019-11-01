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
class DataService {
    
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
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String,String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func sendMessgaeToFirebase(toId: String, properties: [String:Any], completeion: (_ result:Bool)->()){
        
        guard let fromId = Auth.auth().currentUser?.uid else{return}
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let childRef = REF_MESSAGES.childByAutoId()
        var dict:[String : Any] = ["toId":toId, "fromId":fromId,"timeStamp":timestamp]
        
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
            self.observeNotification(fromId: fromId, toId: toId)
        })
        completeion(true)
        
    }
    
    private func observeNotification(fromId: String, toId: String){
        
        self.NOTIFICATION.child(toId).child(fromId).setValue(true, withCompletionBlock: { (err,ref) in
            
            if err == nil{
                print("Notification sent successfully")
            }else{
                print("Notification sent UnSuccessfully")
                return
            }
            
        })
        
    }
    
    func getUserWithId(id: String, completion: @escaping (_ user: User?)->()){
        REF_USERS.child(id).observe(.value, with: { snapshot in
            guard let dict = snapshot.value as? [String:Any] else{
                return
            }
            let user = User(userData: dict)
            completion(user)
            
        })
    }
}

