//
//  File.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/21/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class Message{
    var text:String?
    var fromId:String?
    var toId:String?
    
    init(msg: Dictionary<String,Any>) {
        self.text = msg["text"] as! String
        self.fromId = msg["fromId"] as! String
        self.toId = msg["toId"] as! String
    }
    
    func partnerID() -> String?{
        return fromId == Auth.auth().currentUser!.uid ? toId : fromId
    }
}
