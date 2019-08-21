//
//  User.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/16.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import Foundation

struct User {
    
    enum Sex: String {
        case man = "10"
        case woman = "01"
    }
    
    var id: String
    var name: String
    var sex: Sex
    var email: String
    var birthday: String
    var photoPath: String?
    
    static func getSexString(code: String) -> String {
        if code == "10" {
            return "男性"
        } else if code == "01" {
            return "女性"
        } else {
            return "--"
        }
    }
}
