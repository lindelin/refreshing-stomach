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
