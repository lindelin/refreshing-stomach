//
//  EmailVerificationController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/13.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import Firebase

class EmailVerificationController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }
    
    func updateUI() {
        emailLabel.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func resendButtonHastapped(_ sender: Any) {
        Auth.auth().useAppLanguage()
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if let error = error {
                self.showErrorMessage(message: error.localizedDescription)
                return
            }
            
            self.showErrorMessage(message: "確認メールを再送信しました。")
        })
    }
    
    @IBAction func logoutButtonHasTapped(_ sender: Any) {
        self.logout()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
