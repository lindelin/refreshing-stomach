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
    
    @IBOutlet weak var logButton: WKInterfaceButton!
    @IBOutlet weak var messageLabel: WKInterfaceLabel!
    
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
            self.createLog(type: "home")
        }
        
        let officeAction = WKAlertAction(title: "勤務先", style: .default) {
            self.createLog(type: "office")
        }
        
        let othersAction = WKAlertAction(title: "その他", style: .default) {
            self.createLog(type: "others")
        }
        presentAlert(withTitle: nil, message: "場所を選択してください", preferredStyle: .actionSheet, actions: [homeAction, officeAction, othersAction])
    }
    
    func createLog(type: String) {
        self.messageLabel.setText("記録中...")
        self.session?.sendMessage([
            "type": type
            ], replyHandler: { (reply) in
                if reply["status"] as! String == "NG" {
                    let cancelAction = WKAlertAction(title: "了解", style: .cancel, handler: {})
                    self.presentAlert(withTitle: nil, message: reply["message"] as? String, preferredStyle: .alert, actions: [cancelAction])
                    self.messageLabel.setText("記録しましょう〜")
                    return
                }
                
                self.messageLabel.setText("記録しました！")
        }, errorHandler: { (error) in
            print(error)
            self.messageLabel.setText("記録しましょう〜")
            let cancelAction = WKAlertAction(title: "了解", style: .cancel, handler: {})
            self.presentAlert(withTitle: "エラー", message: "記録するには、iPhone と通信しなければなりません。", preferredStyle: .alert, actions: [cancelAction])
        })
    }
}
