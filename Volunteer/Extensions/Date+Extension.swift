//
//  Date+Extension.swift
//  Volunteer
//
//  Created by Hady Hammad on 3/7/20.
//  Copyright © 2020 Hady Hammad. All rights reserved.
//

import Foundation
extension Date{
    func calendarTimeSinceNow() -> String{
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        let years = components.year!
        let months = components.month!
        let days = components.day!
        let hours = components.hour!
        let minutes = components.minute!
        let seconds = components.second!
        
        if years > 0{
            if Language.currentLanguage == .arabic{
                return years == 1 ? "منذ سنة واحدة" : "منذ \(years) سنوات"
            }else{
                return years == 1 ? "1 year ago" : "\(years) years ago"
            }
        }else if months > 0{
            if Language.currentLanguage == .arabic{
                return months == 1 ? "منذ شهر واحد" : "منذ \(months) شهور"
            }else{
                return months == 1 ? "1 month ago" : "\(months) months ago"
            }
        }else if days >= 7{
            let weeks = days / 7
            if Language.currentLanguage == .arabic{
                return weeks == 1 ? "منذ اسبوع واحد" : "منذ \(weeks) اسابيع"
            }else{
                return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
            }
        }else if days > 0{
            if Language.currentLanguage == .arabic{
                return days == 1 ? "منذ يوم واحد" : "منذ \(days) ايام"
            }else{
                return days == 1 ? "1 day ago" : "\(days) days ago"
            }
        }else if hours > 0{
            if Language.currentLanguage == .arabic{
                return hours == 1 ? "منذ اسبوع واحد" : "منذ \(hours) ساعة"
            }else{
                return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
            }
        }else if minutes > 0{
            if Language.currentLanguage == .arabic{
                return minutes == 1 ? "منذ دقيقة واحدة" : "منذ \(minutes) دقائق"
            }else{
                return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
            }
        }else{
            if Language.currentLanguage == .arabic{
                return seconds == 1 ? "منذ ثانية واحدة" : "منذ \(seconds) ثواني"
            }else{
                return seconds == 1 ? "1 second ago" : "\(seconds) seconds ago"
            }
        }
        
    }
}
