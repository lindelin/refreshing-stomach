//
//  RegistUserInfoController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/14.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import Firebase

class RegistUserInfoController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTextField()
    }
    
    func setupTextField() {
        nameField.delegate = self
        birthdayField.delegate = self
    }
    
    @IBAction func addPhotoButtonHasTapped(_ sender: Any) {
    }
    
    @IBAction func startButtonHasTapped(_ sender: Any) {
        guard let name = nameField.text, name.count > 0 else {
            self.showErrorMessage(message: "ニックネームは必須です。")
            return
        }
        
//        guard let birthday = birthdayField.text, name.count > 0 else {
//            self.showErrorMessage(message: "生年月日は必須です。")
//            return
//        }
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let request = user.createProfileChangeRequest()
        request.displayName = name
        request.commitChanges { (error) in
            if let error = error {
                self.showErrorMessage(message: error.localizedDescription)
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainController = storyboard.instantiateViewController(withIdentifier: "MainView")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RegistUserInfoController: UITextFieldDelegate {
    // MARK: - Doneボタン押下でキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            birthdayField.becomeFirstResponder()
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
