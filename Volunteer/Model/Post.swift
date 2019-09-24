//
//  Post.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/1/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import Firebase
struct Post{
    var id:String
    var imgUrl:String
    var pdfUrl:String
    var postText:String
    var likes:Int
    var type:String
    var postKey:String
    var postRef:DatabaseReference!
    
    init(postKey: String, post: Dictionary<String,Any>) {
        self.postKey = postKey
        self.id = post["Id"] as! String
        self.imgUrl = post["ImageUrl"] as! String
        self.pdfUrl = post["PDFURL"] as! String
        self.postText = post["Text"] as! String
        self.likes = post["Likes"] as! Int
        self.type = post["donationType"] as! String
        postRef = DataService.db.REF_POST.child(postKey)
    }
    
    mutating func adjustLikes(addLike: Bool){
        if addLike{
            likes = likes + 1
        }else{
            likes = likes - 1
        }
        postRef.child("Likes").setValue(likes)
    }
}
