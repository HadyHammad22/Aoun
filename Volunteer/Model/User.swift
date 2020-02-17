//
//  User.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/30/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
struct User: Decodable{
    var name:String
    var phone:String
    var city:String
    var email:String
    var password:String
}
