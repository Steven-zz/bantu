//
//  LogInViewController.swift
//  Bantu
//
//  Created by Cason Kang on 01/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import FirebaseAuth
import UIKit
import SwiftOverlays

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInBtnOutlet: UIButton!
    @IBOutlet weak var signUpBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //textfield delegate
        emailField.delegate = self
        passwordField.delegate = self
        signInBtnOutlet.buttonDesign()
        signUpBtnOutlet.setTitleColor(.bantuBlue, for: .normal)
        
        // end editing keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismiss(_:)))
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    @IBAction func loginBtn(_ sender: UIButton) {
        self.becomeFirstResponder()
        guard let email = emailField.text, email != "" else {
            let alertController = UIAlertController(title: "Error", message: "Masukan e-mail Anda", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let password = passwordField.text, password != "" else {
            let alertController = UIAlertController(title: "Error", message: "Masukan password Anda", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        SwiftOverlays.showBlockingWaitOverlayWithText("Menghubungi Server")
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error == nil {
                SwiftOverlays.removeAllBlockingOverlays()
                let userID: String = Auth.auth().currentUser!.uid
                
                UserServices.getUser(withID: userID) { user in
                    guard let user = user else { return }
                    GlobalSession.login(user: user)
                    
                    DispatchQueue.main.sync {
                        SwiftOverlays.removeAllBlockingOverlays()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                SwiftOverlays.removeAllBlockingOverlays()
                let errorCode = error! as NSError
                var errorMessage = String()
                
                switch errorCode.code{
                case AuthErrorCode.invalidEmail.rawValue:
                    errorMessage = "Format email tidak tepat"
                case AuthErrorCode.wrongPassword.rawValue:
                    errorMessage = "Kata sandi tidak tepat"
                case AuthErrorCode.userNotFound.rawValue:
                    errorMessage = "Akun Anda tidak valid"
                case AuthErrorCode.userDisabled.rawValue:
                    errorMessage = "Akun Anda telah diblokir"
                case AuthErrorCode.networkError.rawValue:
                    errorMessage = "Internet Anda sedang mengalami gangguan"
                case AuthErrorCode.userTokenExpired.rawValue:
                    errorMessage = "Telah terjadi perubahan pada akun Anda. Tolong masuk kembali ke akun Anda"
                case AuthErrorCode.tooManyRequests.rawValue:
                    errorMessage = "Data server sedang mengalami masalah. Silakan coba lagi beberapa saat"
                default:
                    errorMessage = error.debugDescription
                }
                
                let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismiss(_ button: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension
//text field return
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
