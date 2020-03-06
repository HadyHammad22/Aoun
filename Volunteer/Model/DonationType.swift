//
//  DonationType.swift
//  Volunteer
//
//  Created by Hady Hammad on 3/5/20.
//  Copyright © 2020 Hady Hammad. All rights reserved.
//

import Foundation

struct DonationType{
    var type:String?
    var arabicType:String?
    var id:Int?
    
    init(id: Int, DonationType: Dictionary<String,Any>) {
        self.id = id
        self.type = DonationType["type"] as? String
        self.arabicType = DonationType["arabicType"] as? String
    }
}
