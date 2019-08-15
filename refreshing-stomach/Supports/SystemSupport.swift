//
//  SystemSupport.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/15.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import Foundation

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
}
