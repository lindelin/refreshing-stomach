//
//  InterfaceController.swift
//  refreshing-stomach-watch Extension
//
//  Created by LINDALE on 2019/08/25.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        startSession()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("AppleWatchペアリング完了")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext)
    }
    
    @IBAction func logButtonHasTapped() {
        
        let homeAction = WKAlertAction(title: "ご自宅", style: .default) {
            self.session?.sendMessage([
                "type": "home"
                ], replyHandler: { (reply) in
                    print(reply)
            }, errorHandler: { (error) in
                print(error)
            })
        }
        
        let officeAction = WKAlertAction(title: "勤務先", style: .default) {
            print("sdgsdfsd")
        }
        
        let othersAction = WKAlertAction(title: "その他", style: .default) {
            print("sdgsdfsd")
        }
        presentAlert(withTitle: nil, message: "場所を選択してください", preferredStyle: .actionSheet, actions: [homeAction, officeAction, othersAction])
    }
}
