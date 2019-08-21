//
//  LoginController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/13.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD

class LoginController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTextField()
    }
    
    func setupTextField() {
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func loginButtonHasTapped(_ sender: Any) {
        
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        
        Auth.auth().useAppLanguage()
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let authResult = authResult, error == nil else {
                self.showErrorMessage(message: error!.localizedDescription)
                return
            }
            
            guard authResult.user.isEmailVerified else {
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                let emailVerificationController = storyboard.instantiateViewController(withIdentifier: "EmailVerificationView") as! EmailVerificationController
                UIView.transition(from: self.view, to: emailVerificationController.view, duration: 0.6, options: [.transitionCrossDissolve], completion: { _ in
                    UIApplication.shared.keyWindow?.rootViewController = emailVerificationController
                })
                return
            }
            
            guard let name = authResult.user.displayName, name.count > 0 else {
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                let registUserInfoController = storyboard.instantiateViewController(withIdentifier: "RegistUserInfoView") as! RegistUserInfoController
                UIView.transition(from: self.view, to: registUserInfoController.view, duration: 0.6, options: [.transitionCrossDissolve], completion: { _ in
                    UIApplication.shared.keyWindow?.rootViewController = registUserInfoController
                })
                return
            }
            
            KRProgressHUD.show()
            
            let ref: DocumentReference = self.db.collection("users").document(authResult.user.uid)
            
            ref.getDocument(completion: { (document, error) in
                if let document = document, document.exists, let data = document.data() {
                    UserDefaults.setUser(data["name"], forKey: .name)
                    UserDefaults.setUser(data["birthday"], forKey: .birthday)
                    UserDefaults.setUser(data["sex"], forKey: .sexCode)
                    UserDefaults.setUser(data["photoPath"], forKey: .photoPath)
                    UserDefaults.setUser(User.getSexString(code: data["sex"] as! String), forKey: .sex)
                    UserDefaults.standard.synchronize()
                    
                    let photoRef = self.storage.reference(withPath: data["photoPath"] as! String)
                    photoRef.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                        KRProgressHUD.dismiss()
                        
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        let photo = UIImage(data: data!)
                        photo?.saveAsUserPhoto()
                    })
                    
                }
            })
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainController = storyboard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
            mainController.selectedIndex = 0
            UIView.transition(from: self.view, to: mainController.view, duration: 0.6, options: [.transitionCrossDissolve], completion: {
                _ in
                UIApplication.shared.keyWindow?.rootViewController = mainController
            })
        }
    }
    
    // キーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToLoginView(unwindSegue: UIStoryboardSegue) {
        print(unwindSegue)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension LoginController: UITextFieldDelegate {
    // MARK: - Doneボタン押下でキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordField.becomeFirstResponder()
            break
        case 1:
            textField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
}
