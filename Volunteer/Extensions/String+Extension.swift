//
//  String+Extension.swift
//  Volunteer
//
//  Created by Hady Hammad on 2/13/20.
//  Copyright © 2020 Hady Hammad. All rights reserved.
//

import Foundation
extension String{
    
    
    func getDateFromString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //TimeZone.current//
        dateFormatter.locale = Locale(identifier: "en_US")
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        if let date = dateFormatter.date(from: self) {
            return dateFormatter.date(from: dateFormatter.string(from: date))//date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        return nil
    }
    
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func trimmedLength() -> Int {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).count
    }
    
    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    func indexInt(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
        
    }
    
    var validatePhoneNumber: Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    
}
