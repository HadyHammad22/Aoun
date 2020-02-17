//
//  Post.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/1/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import Firebase
struct Post: Decodable{
    var Id:String
    var ImageUrl:String
    var PDFURL:String
    var Text:String
    var Likes:Int
    var donationType:String
    var postKey:String
    mutating func adjustLikes(addLike: Bool){
        if addLike{
            Likes = Likes + 1
        }else{
            Likes = Likes - 1
        }
        DataService.db.REF_POST.child(postKey).child("Likes").setValue(Likes)
    }
}
