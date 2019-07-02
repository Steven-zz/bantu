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
        
    }

    @IBAction func signUpBtn(_ sender: Any) {
        let charactersetName = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. ")
        let charactersetPhone = CharacterSet(charactersIn: "+1234567890")
        
        //validation for text fields
        guard let fullName = fullNameTextField.text, fullName != "" , fullName.first != " " , fullName.rangeOfCharacter(from: charactersetName.inverted) == nil else {
            let alertController = UIAlertController(title: "Error", message: "Masukan nama Anda. Nama tidak boleh diawali dengan spasi atau mengandung karakter spesial", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            signUpBtn.isEnabled = true
            return
        }
        guard let telephone = telephoneTextField.text, telephone != "" , !telephone.contains(" ") , telephone.rangeOfCharacter(from: charactersetPhone.inverted) == nil else {
            let alertController = UIAlertController(title: "Error", message: "Masukan Nomor Telepon Anda dengan benar", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            signUpBtn.isEnabled = true
            return
        }
        guard let email = emailTextField.text, email != "" , !email.contains(" ") else {
            let alertController = UIAlertController(title: "Error", message: "Masukan email Anda, username tidak boleh ada spasi", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            signUpBtn.isEnabled = true
            return
        }
        guard let password = passwordTextField.text, password != "" , !password.contains(" ") else {
            let alertController = UIAlertController(title: "Error", message: "Masukan password Anda, password tidak boleh ada spasi", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            signUpBtn.isEnabled = true
            return
        }
        guard let confirmPassword = confirmPasswordTextField.text, confirmPassword != "" else {
            let alertController = UIAlertController(title: "Error", message: "Konfirmasi password Anda", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            signUpBtn.isEnabled = true
            return
        }
        
        //check if password is equal
        if password != confirmPassword {
            let alertController = UIAlertController(title: "Error", message: "Konfirmasi kata sandi salah", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            signUpBtn.isEnabled = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
        }
    }

}
