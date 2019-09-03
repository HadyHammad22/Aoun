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
    
    var REF_POST_IMAGE: StorageReference{
        return _REF_POST_IMAGE
    }
    
    var REF_POST_PDF: StorageReference{
        return _REF_POST_PDF
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String,String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
}

