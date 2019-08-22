//
//  SystemSupport.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/15.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    static func now() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: Date())
    }
    
    static func createFormFormat(string date: String, format: String = "yyyy/MM/dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.date(from: date)
        return date
    }
    
    func format(_ format: String = "yyyy/MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func age() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: now)
        let age = ageComponents.year!
        
        return age
    }
    
    func toStringWithCurrentLocale() -> String {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        return formatter.string(from: self)
    }
}

extension UIImage {
    func saveAsUserPhoto() {
        let photoData = self.jpegData(compressionQuality: 1.0)
        if let photoData = photoData {
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let archiveURL = cachesDirectory.appendingPathComponent("UserPhoto").appendingPathExtension("jpg")
            try? photoData.write(to: archiveURL)
            print("保存しました：", archiveURL)
        }
    }
    
    static func getUserPhoto() -> UIImage? {
        do {
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let archiveURL = cachesDirectory.appendingPathComponent("UserPhoto").appendingPathExtension("jpg")
            let data = try Data(contentsOf: archiveURL)
            let image = UIImage(data: data)
            return image
        } catch {
            return nil
        }
    }
}

extension Log: Encodable {
    private enum CodingKeys: String, CodingKey {
        case id, type
        case createdAt = "created_at"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id?.uuidString, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(createdAt, forKey: .createdAt)
    }
}

extension Date {
    // Returns the number of years
    func yearsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
    }
    // Returns the number of months
    func monthsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: Date()).month ?? 0
    }
    // Returns the number of weeks
    func weeksCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: Date()).weekOfMonth ?? 0
    }
    // Returns the number of days
    func daysCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
    // Returns the number of hours
    func hoursCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
    }
    // Returns the number of minutes
    func minutesCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: Date()).minute ?? 0
    }
    // Returns the number of seconds
    func secondsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: Date()).second ?? 0
    }
    // Returns time ago by checking if the time differences between two dates are in year or months or weeks or days or hours or minutes or seconds
    func diffForHumans() -> String {
        if yearsCount(from: self)   > 0 { return "\(yearsCount(from: self)) 年前"   }
        if monthsCount(from: self)  > 0 { return "\(monthsCount(from: self)) 月前"  }
        if weeksCount(from: self)   > 0 { return "\(weeksCount(from: self)) 週前"   }
        if daysCount(from: self)    > 0 { return "\(daysCount(from: self)) 日前"    }
        if hoursCount(from: self)   > 0 { return "\(hoursCount(from: self)) 時間前"   }
        if minutesCount(from: self) > 0 { return "\(minutesCount(from: self)) 分前" }
        if secondsCount(from: self) > 0 { return "\(secondsCount(from: self)) 秒前" }
        return ""
    }
}
