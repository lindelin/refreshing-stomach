//
//  UserDefaultsSupport.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/15.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    enum UserInfo: String {
        case name = "userName"
        case birthday = "userBirthday"
        case sex = "userSex"
    }
    
    static func setUser(_ value: Any?, forKey userInfoKey: UserInfo) {
        UserDefaults.standard.set(value, forKey: userInfoKey.rawValue)
    }
    
    static func getUser(forKey userInfoKey: UserInfo) -> String? {
        return UserDefaults.standard.string(forKey: userInfoKey.rawValue)
    }
}
