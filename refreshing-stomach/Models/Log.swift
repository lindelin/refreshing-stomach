//
//  Log.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/21.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import Foundation

enum LogType: String {
    case home = "100"
    case office = "010"
    case others = "001"
    
    func name() -> String {
        switch self {
        case .home:
            return "ご自宅"
        case .office:
            return "勤務先"
        default:
            return "その他"
        }
    }
    
    static func name(code: String) -> String {
        switch code {
        case "100":
            return "🏠ご自宅"
        case "010":
            return "🏢勤務先"
        default:
            return "❓その他"
        }
    }
}
