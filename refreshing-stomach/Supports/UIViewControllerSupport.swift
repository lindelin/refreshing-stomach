//
//  UIViewControllerSupport.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/13.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    func showErrorMessage(message: String) {
        let alertView = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "了解", style: .default) { (_) in
            alertView.dismiss(animated: true)
        }
        
        alertView.addAction(okButton)
        
        self.present(alertView, animated: true)
    }
    
    func logout() {
        let actionSheet = UIAlertController(title: nil, message: "ログアウトします、よろしいですか？", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "ログアウト", style: .default) { (_) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                let welcomeController = storyboard.instantiateViewController(withIdentifier: "WelcomeView") as! WelcomeController
                UIView.transition(from: self.tabBarController?.view ?? self.view, to: welcomeController.view, duration: 0.6, options: [.transitionCrossDissolve], completion: { _ in
                    UIApplication.shared.keyWindow?.rootViewController = welcomeController
                })
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
            actionSheet.dismiss(animated: true)
        }
        
        actionSheet.addAction(logoutAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
}
