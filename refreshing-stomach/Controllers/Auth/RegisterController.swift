//
//  RegisterController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/13.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTextField()
    }
    
    func setupTextField() {
        emailField.delegate = self
        passwordField.delegate = self
        passwordConfirmationField.delegate = self
    }
    
    @IBAction func nextButtonHasTapped(_ sender: Any) {
        guard let email = emailField.text, email.count > 0 else {
            self.showErrorMessage(message: "メールアドレスは必ず入力してください。")
            return
        }
        
        guard let password = passwordField.text, let passwordConfirmation = passwordConfirmationField.text, password.count > 0 else {
            self.showErrorMessage(message: "パスワードは必ず入力してください。")
            return
        }
        
        guard password == passwordConfirmation else {
            self.showErrorMessage(message: "パスワードとパスワード確認は一致しません。")
            return
        }
        
        Auth.auth().useAppLanguage()
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.showErrorMessage(message: error!.localizedDescription)
                return
            }
            Auth.auth().useAppLanguage()
            user.sendEmailVerification(completion: { (error) in
                if let error = error {
                    self.showErrorMessage(message: error.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "EmailVerificationSegue", sender: nil)
            })
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

extension RegisterController: UITextFieldDelegate {
    // MARK: - Doneボタン押下でキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordField.becomeFirstResponder()
            break
        case 1:
            passwordConfirmationField.becomeFirstResponder()
            break
        case 2:
            textField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
}
