//
//  WatchSupport.swift
//  refreshing-stomach
//
//  Created by LINDALE on 2019/08/25.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import WatchConnectivity
import Firebase

class WatchSession: NSObject, WCSessionDelegate {
    
    static let main = WatchSession()
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    func startSession(){
        session?.delegate = self
        session?.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch APP が確認できました。")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let _ = Auth.auth().currentUser else {
            replyHandler([
                "status": "NG",
                "message": "iPhone でログインしてから、登録しましょう〜"
                ])
        
            return
        }
        
        createLog(type: message["type"] as! String)
        
        replyHandler(["status": "OK"])
    }
    
    func createLog(type: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let log = Log(context: appDelegate.persistentContainer.viewContext)
        log.id = UUID()
        log.createdAt = Date()
        
        switch type {
        case "home":
            log.type = LogType.home.rawValue
            break
        case "office":
            log.type = LogType.office.rawValue
            break
        default:
            log.type = LogType.others.rawValue
            break
        }
        
        appDelegate.saveContext()
        
        NotificationCenter.default.post(name: LocalNotification.logHasCreated, object: nil)
    }
    
}
