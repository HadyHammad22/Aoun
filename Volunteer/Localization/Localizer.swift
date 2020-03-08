//
//  Localizer.swift
//  Volunteer
//
//  Created by Hady Hammad on 3/3/20.
//  Copyright © 2020 Hady Hammad. All rights reserved.
//

import UIKit

class Localizer: NSObject {
    static func localize() {
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
        MethodSwizzleGivenClassName(cls: UITextField.self, originalSelector: #selector(UITextField.awakeFromNib), overrideSelector: #selector(UITextField.cstmAwakeFromNib))
        
        MethodSwizzleGivenClassName(cls: UITextView.self, originalSelector: #selector(UITextView.awakeFromNib), overrideSelector: #selector(UITextView.cstmAwakeFromNib))
        
        MethodSwizzleGivenClassName(cls: UILabel.self, originalSelector: #selector(UILabel.awakeFromNib), overrideSelector: #selector(UILabel.cstmAwakeFromNib))
        MethodSwizzleGivenClassName(cls: UIButton.self, originalSelector: #selector(UIButton.awakeFromNib), overrideSelector: #selector(UIButton.cstmAwakeFromNib))
    }
}

extension UIApplication {
    class func isRTL() -> Bool{
        return Language.currentLanguage == .arabic
    }
}
extension Bundle {
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        if self == Bundle.main {
            let currentLanguage = Language.currentLanguage.rawValue
            var bundle = Bundle();
            
            if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                bundle = Bundle(path: _path)!
            } else {
                let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
                bundle = Bundle(path: _path)!
            }
            
            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
        } else {
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
    }
    var localizedMain : Bundle {
        
        get {
            if let path = Bundle.main.path(forResource: UIApplication.isRTL() ? "ar" : "en", ofType: "lproj") {
                
                if let bundle = Bundle.init(path: path) {
                    return bundle
                } else {
                    return Bundle.main
                }
                
            } else {
                return Bundle.main
            }
        }
        
    }
}

extension UILabel {
    @objc public func cstmAwakeFromNib() {
        self.cstmAwakeFromNib()
        if self.textAlignment == .center { return }
        
        if UIApplication.isRTL()  {
            if self.textAlignment == .right { return }
            self.textAlignment = .right
        } else {
            if self.textAlignment == .left { return }
            self.textAlignment = .left
        }
    }
}

extension UITextField {
    @objc public func cstmAwakeFromNib() {
        self.cstmAwakeFromNib()
        if self.textAlignment == .center { return }
        if UIApplication.isRTL()  {
            if self.textAlignment == .right { return }
            self.textAlignment = .right
        } else {
            if self.textAlignment == .left { return }
            self.textAlignment = .left
        }
    }
}

extension UITextView {
    @objc public func cstmAwakeFromNib() {
        self.cstmAwakeFromNib()
        if self.textAlignment == .center { return }
        if UIApplication.isRTL()  {
            if self.textAlignment == .right { return }
            self.textAlignment = .right
        } else {
            if self.textAlignment == .left { return }
            self.textAlignment = .left
        }
    }
}

extension UIButton {
    @objc public func cstmAwakeFromNib() {
        self.cstmAwakeFromNib()
        if self.contentHorizontalAlignment == .center { return }
        if UIApplication.isRTL()  {
            if self.contentHorizontalAlignment == .right { return }
            self.contentHorizontalAlignment = .right
        } else {
            if self.contentHorizontalAlignment == .left { return }
            self.contentHorizontalAlignment = .left
        }
    }
}

func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

