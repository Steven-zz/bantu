//
//  SignUpViewController.swift
//  Bantu
//
//  Created by Cason Kang on 02/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import FirebaseAuth
import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: TextFieldExtension!
    @IBOutlet weak var telephoneTextField: TextFieldExtension!
    @IBOutlet weak var emailTextField: TextFieldExtension!
    @IBOutlet weak var passwordTextField: TextFieldExtension!
    @IBOutlet weak var confirmPasswordTextField: TextFieldExtension!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpBtn.buttonDesign()
        fullNameTextField.delegate = self
        telephoneTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        // end editing keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }

    @IBAction func signUpBtn(_ sender: Any) {
        let charactersetName = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. ")
        let charactersetPhone = CharacterSet(charactersIn: "+1234567890")
        
        //validation for text fields
        guard let fullName = fullNameTextField.text, fullName != "" , fullName.first != " " , fullName.rangeOfCharacter(from: charactersetName.inverted) == nil else {
            makeAlert(title: "Error", message: "Masukan nama Anda. Nama tidak boleh diawali dengan spasi atau mengandung karakter spesial")
            return
        }
        guard let telephone = telephoneTextField.text, telephone != "" , !telephone.contains(" ") , telephone.rangeOfCharacter(from: charactersetPhone.inverted) == nil else {
            makeAlert(title: "Error", message: "Masukan Nomor Telepon Anda dengan benar")
            return
        }
        guard let email = emailTextField.text, email != "" , !email.contains(" ") else {
            makeAlert(title: "Error", message: "Masukan email Anda, username tidak boleh ada spasi")
            return
        }
        guard let password = passwordTextField.text, password != "" , !password.contains(" ") else {
            makeAlert(title: "Error", message: "Masukan password Anda, password tidak boleh ada spasi")
            return
        }
        guard let confirmPassword = confirmPasswordTextField.text, confirmPassword != "" else {
            makeAlert(title: "Error", message: "Konfirmasi password Anda")
            return
        }
        
        //check if password is equal
        if password != confirmPassword {
            makeAlert(title: "Error", message: "Konfirmasi kata sandi salah")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                let userID: String = Auth.auth().currentUser!.uid
                let user = User(userID: userID, roleID: 2, email: email, phone: telephone, fullName: fullName)
                UserServices.postUser(user: user) { isSuccess in
                    if isSuccess {
                        DispatchQueue.main.sync {
                            self.makeAlert(title: "Sukses", message: "Akun berhasil terdaftar")
                        }
                    } else {
                        // error di db
                    }
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        signUpBtn.isEnabled = true
    }
}

// MARK: - Extension
//text field return
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
