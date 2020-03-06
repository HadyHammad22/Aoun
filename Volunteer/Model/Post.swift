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
    var userID: String?
    var imgUrl: String?
    var pdfUrl: String?
    var postText: String?
    var likes: Int?
    var donationType: String?
    var arabicDonationType: String?
    var createdAt: Date?
    var postKey: String?
    
    init(postKey: String, post: Dictionary<String,Any>) {
        self.postKey = postKey
        self.userID = post["userID"] as? String
        if let donationType = post["donationType"] as? [String:Any] {
            guard let type = donationType["type"] as? String else{return}
            guard let arabicType = donationType["arabicType"] as? String else{return}
            self.donationType = type
            self.arabicDonationType = arabicType
        }
        self.imgUrl = post["imageUrl"] as? String
        self.pdfUrl = post["pdfURL"] as? String
        self.postText = post["text"] as? String
        self.likes = post["likes"] as? Int
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
        DataService.db.REF_POST.child(postKey!).child("likes").setValue(likes)
    }
}
