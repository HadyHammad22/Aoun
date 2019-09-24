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
    
    //DB_references
    let _REF_BASE = DB_BASE
    let _REF_USERS = DB_BASE.child("users")
    let _REF_POST = DB_BASE.child("post")
    let _REF_MESSAGES = DB_BASE.child("messages")
    let _REF_USER_MESSAGES = DB_BASE.child("user-messages")
    let _REF_POST_IMAGE = STORAGE_BASE.child("post-pics")
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
    
    var REF_POST_IMAGE: StorageReference{
        return _REF_POST_IMAGE
    }
    
    var REF_POST_PDF: StorageReference{
        return _REF_POST_PDF
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String,String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func sendMessgaeToFirebase(msg: String, ownerID: String, completeion: (_ result:Bool)->()){
        guard let fromId = Auth.auth().currentUser?.uid else{return}
        let dict = ["text":msg, "toId":ownerID, "fromId":fromId]
        let childRef = REF_MESSAGES.childByAutoId()
        childRef.updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
            let receiptionUserMessagesRef = self.REF_USER_MESSAGES.child(ownerID)
            let msgID = childRef.key
            receiptionUserMessagesRef.updateChildValues([msgID!: true])
            
            let userMessagesRef = self.REF_USER_MESSAGES.child(fromId)
            userMessagesRef.updateChildValues([msgID!: true])
        })
        completeion(true)
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

