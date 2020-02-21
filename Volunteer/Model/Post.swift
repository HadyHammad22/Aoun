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
    var id:String?
    var imgUrl:String?
    var pdfUrl:String?
    var postText:String?
    var likes:Int?
    var type:String?
    var createdAt:Date?
    var postKey:String?
    
    init(postKey: String, post: Dictionary<String,Any>) {
        self.postKey = postKey
        self.id = post["Id"] as? String
        self.type = post["donationType"] as? String
        self.imgUrl = post["ImageUrl"] as? String
        self.pdfUrl = post["PDFURL"] as? String
        self.postText = post["Text"] as? String
        self.likes = post["Likes"] as? Int
        if let timestamp = post["timestamp"] as? Double{
            self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
        }
    }
    
    mutating func adjustLikes(addLike: Bool){
        if addLike{
            likes = likes! + 1
        }else{
            likes = likes! - 1
        }
        DataService.db.REF_POST.child(postKey!).child("Likes").setValue(likes)
    }
}
