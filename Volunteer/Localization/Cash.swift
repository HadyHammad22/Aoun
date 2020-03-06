//
//  Cash.swift
//  Volunteer
//
//  Created by Hady Hammad on 3/3/20.
//  Copyright © 2020 Hady Hammad. All rights reserved.
//

import UIKit

class Cache: NSObject {
    private static func archiveUserInfo(info : Any) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: info) as NSData
    }
    
    class func object(key:String) -> Any? {
        if let unarchivedObject = UserDefaults.standard.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data)
        }
        return nil
    }
    
    class func set(object : Any? ,forKey key:String) {
        let archivedObject = archiveUserInfo(info: object!)
        UserDefaults.standard.set(archivedObject, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
