//
//  Language.swift
//  Volunteer
//
//  Created by Hady Hammad on 3/3/20.
//  Copyright © 2020 Hady Hammad. All rights reserved.
//


import UIKit

let APPLE_LANGUAGE_KEY = "AppleLanguages"

class Language: NSObject {
    
    static var currentLanguage : AppLanguage {
        var langStr = "en"
        if let lang = Cache.object(key: "currentLang") as? String {
            langStr = lang
        } else {
            langStr = Locale.current.languageCode!
        }
        return langStr == "ar" ? .arabic : .english
    }
    
    static func setCurrentLanguage(lang : AppLanguage) {
        Cache.set(object: lang.rawValue, forKey: "currentLang")
        UserDefaults.standard.set([lang.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    static func swichLanguage() {
        switch Language.currentLanguage {
        case .arabic:
            self.setCurrentLanguage(lang: .english)
            break
        case .english:
            self.setCurrentLanguage(lang: .arabic)
            break
        }
    }
    
    class var isRTL: Bool {
        return Language.currentLanguage == .arabic
    }
    
}

enum AppLanguage : String {
    case arabic = "ar"
    case english = "en"
}

extension UIApplication {
    class func initWindow(){
        (UIApplication.shared.delegate as! AppDelegate).initWindow()
    }
}
