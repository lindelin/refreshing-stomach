//
//  RegistUserInfoController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/14.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class RegistUserInfoController: UIViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()

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
        
        self.birthdayField.addTarget(self, action: #selector(self.birthdayEditing), for: .editingDidBegin)
    }
    
    @objc func birthdayEditing(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.setDate(Date(), animated: true)
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.birthdayPickerValueChanged), for: .valueChanged)
    }
    
    @objc func birthdayPickerValueChanged(sender: UIDatePicker) {
        self.birthdayField.text = sender.date.format()
    }
    
    @IBAction func addPhotoButtonHasTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let selectPhotoAction = UIAlertAction(title: "画像を選択", style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                self.showErrorMessage(message: "アルバムにアクセスする許可を設定してください。")
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        let takePhotoAction = UIAlertAction(title: "写真を撮る", style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                self.showErrorMessage(message: "カメラにアクセスする許可を設定してください。")
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
            actionSheet.dismiss(animated: true)
        }
        
        actionSheet.addAction(selectPhotoAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func startButtonHasTapped(_ sender: Any) {
        guard let name = nameField.text, name.count > 0 else {
            self.showErrorMessage(message: "ニックネームは必須です。")
            return
        }
        
        guard let birthday = birthdayField.text, name.count > 0 else {
            self.showErrorMessage(message: "生年月日は必須です。")
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let ref: DocumentReference = db.collection("users").document(user.uid)
        ref.setData([
            "id": user.uid,
            "name": name,
            "email": user.email!,
            "birthday": birthday
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref.documentID)")
            }
        }
        
//        let request = user.createProfileChangeRequest()
//        request.displayName = name
//        request.commitChanges { (error) in
//            if let error = error {
//                self.showErrorMessage(message: error.localizedDescription)
//                return
//            }
//
//            UserDefaults.setUser(name, forKey: .name)
//            UserDefaults.setUser(birthday, forKey: .birthday)
//            UserDefaults.standard.synchronize()
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainController = storyboard.instantiateViewController(withIdentifier: "MainView")
//            UIView.transition(from: self.view, to: mainController.view, duration: 0.6, options: [.transitionCrossDissolve], completion: {
//                _ in
//                UIApplication.shared.keyWindow?.rootViewController = mainController
//            })
//        }
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

extension RegistUserInfoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as! String
        
        guard mediaType == (kUTTypeImage as String) else {
            self.showErrorMessage(message: "画像を選択してください。")
            return
        }
        
        let image = info[.editedImage] as! UIImage
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            self.showErrorMessage(message: "画像が使用できません。")
            return
        }
        
        let imageId = UUID().uuidString
        let uploadRef = storage.reference(withPath: "public/\(imageId).jpg")
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetaData, error) in
            if let error = error {
                self.showErrorMessage(message: error.localizedDescription)
                return
            }
            picker.dismiss(animated: true)
        }
    }
}
