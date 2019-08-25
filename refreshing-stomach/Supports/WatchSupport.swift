//
//  WatchSupport.swift
//  refreshing-stomach
//
//  Created by LINDALE on 2019/08/25.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchSession: NSObject, WCSessionDelegate {
    
    static let main = WatchSession()
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    func startSession(){
        session?.delegate = self
        session?.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch APP があります")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print(message)
        replyHandler([
            "message": "うけとりました"
            ])
    }
    
}
