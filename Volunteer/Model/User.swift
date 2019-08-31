//
//  User.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/30/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
struct User{
    var name:String
    var phone:String
    var city:String
    var email:String
    var gender:String
    var password:String
    
    init(userData: Dictionary<String,Any>) {
        self.name = userData["name"] as! String
        self.email = userData["email"] as! String
        self.phone = userData["phone"] as! String
        self.city = userData["city"] as! String
        self.gender = userData["gender"] as! String
        self.password = userData["password"] as! String
    }
}
