//
//  SendPasswordResetMailController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/13.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import Firebase

class SendPasswordResetMailController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTextField()
    }
    
    func setupTextField() {
        emailField.delegate = self
    }
    
    @IBAction func sendButtonHasTapped(_ sender: Any) {
        
        let email = emailField.text ?? ""
        
        Auth.auth().useAppLanguage()
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showErrorMessage(message: error.localizedDescription)
                return
            }
            
            self.performSegue(withIdentifier: "BackToLoginViewSegue", sender: nil)
        }
    }
    
    // キーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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

extension SendPasswordResetMailController: UITextFieldDelegate {
    // MARK: - Doneボタン押下でキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            textField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
}
