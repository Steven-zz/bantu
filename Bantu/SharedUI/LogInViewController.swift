//
//  LogInViewController.swift
//  Bantu
//
//  Created by Cason Kang on 01/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import FirebaseAuth
import UIKit

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
        signUpBtnOutlet.setTitleColor(#colorLiteral(red: 0.1764705882, green: 0.4784313725, blue: 0.5607843137, alpha: 1), for: .normal)
        
        // end editing keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }

    @IBAction func loginBtn(_ sender: UIButton) {
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
        
        let popup = LoadingIndicatorViewController.getIndicatorView()
        self.present(popup, animated: false, completion: nil)
        popup.startAnimating()
        popup.setLbl(activity: "Menghubungi Server")
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error == nil {
                popup.stopAnimating()
                popup.finish()
                let userID = (Auth.auth().currentUser?.uid)!
//                GlobalSession.currentUser = User(userID: <#T##String#>, roleID: <#T##Int#>, email: <#T##String#>, phone: <#T##String#>, fullName: <#T##String#>)
                self.dismiss(animated: true, completion: nil)
                popup.stopAnimating()
                popup.finish()
            } else {
//                popup.stopAnimating()
//                popup.finish()
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
