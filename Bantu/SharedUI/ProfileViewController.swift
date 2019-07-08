//
//  ProfileViewController.swift
//  Bantu
//
//  Created by Cason Kang on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var phoneNoField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var submissionsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GlobalSession.currentUser?.role == .admin {
            submissionsView.isHidden = true
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismiss(_:)))
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        fullNameField.text = GlobalSession.currentUser?.fullName
        phoneNoField.text = GlobalSession.currentUser?.phone
        emailField.text = GlobalSession.currentUser?.email
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toSubmissions(_ sender: UIButton) {
        let vc = UserSubmissionListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func save(_ button: UIBarButtonItem) {
        let charactersetName = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. ")
        let charactersetPhone = CharacterSet(charactersIn: "+1234567890")
        
        //validation for text fields
        guard let fullName = fullNameField.text, fullName != "" , fullName.first != " " , fullName.rangeOfCharacter(from: charactersetName.inverted) == nil else {
            makeAlert(title: "Error", message: "Masukan nama Anda. Nama tidak boleh diawali dengan spasi atau mengandung karakter spesial")
            return
        }
        guard let telephone = phoneNoField.text?.trimmingCharacters(in: .whitespacesAndNewlines), telephone != "" , !telephone.contains(" ") , telephone.rangeOfCharacter(from: charactersetPhone.inverted) == nil else {
            makeAlert(title: "Error", message: "Masukan Nomor Telepon Anda dengan benar")
            return
        }
        guard let email = emailField.text, email != "" , !email.contains(" ") else {
            makeAlert(title: "Error", message: "Masukan email Anda, username tidak boleh ada spasi")
            return
        }
        
        //Save
    }
    
    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Log Out", message: "Apakah anda ingin Log Out?", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            GlobalSession.logout()
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "Batal", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func dismiss(_ button: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
