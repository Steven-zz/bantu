//
//  CreateEventViewController.swift
//  Bantu
//
//  Created by Cason Kang on 06/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit
import MapKit

class CreateEventViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var eventPosterImage: UIImageView!
    
    @IBOutlet weak var eventNameField: CreateDraftFieldExtension!
    @IBOutlet weak var schoolNameField: CreateDraftFieldExtension!
    @IBOutlet weak var schoolNameView: UIView!
    @IBOutlet weak var aboutField: PaddingTextView!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var volunteerNoField: CreateDraftFieldExtension!
    @IBOutlet weak var budgetField: CreateDraftFieldExtension!
    @IBOutlet weak var priceIncludingField: PaddingTextView!
    @IBOutlet weak var picNumberField: CreateDraftFieldExtension!
    @IBOutlet weak var requirementField: PaddingTextView!
    @IBOutlet weak var additionalInfoField: PaddingTextView!
    @IBOutlet weak var schoolLocationMapView: MKMapView!
    
    var post: Post?
    var posterImage: UIImage?
    let datePickerStart = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Buat Event", style: .done, target: self, action: #selector(submit(_:)))
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapDetected)))
        schoolNameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(schoolNameTapDetected)))
    }

    @objc func submit(_ button: UIBarButtonItem) {
        let charactersetPhone = CharacterSet(charactersIn: "+1234567890")
        let charactersetNumbers = CharacterSet(charactersIn: "1234567890")
        
        
        guard let schoolName = schoolNameField.text, schoolName != "", schoolName.first != " " else {
            makeAlert(message: "Nama sekolah tidak boleh kosong")
            return
        }
        
        guard let about = aboutField.text, aboutField.isNotEmpty, about.first != " " else {
            makeAlert(message: "Tentang harus diisi")
            return
        }
        
        
        
        print("YAY")
    }
    
    @objc func schoolNameTapDetected() {
        let vc = AdminSubmissionListViewController(action: .choosePost)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func imageTapDetected() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func makeAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setLocationOnMap(userLocation: CLLocation) {
        let annotation = MKPointAnnotation()
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        schoolLocationMapView.setRegion(region, animated: true)
        annotation.coordinate = myLocation
        schoolLocationMapView.addAnnotation(annotation)
    }
}

extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            
            guard let imageData = image.jpeg(.medium) else { return }
            guard let finalImage = UIImage(data: imageData) else { return }
            
            posterImage = finalImage
            eventPosterImage.isHidden = false
            eventPosterImage.image = posterImage
        }
    }
    
}

extension CreateEventViewController: AdminSubmissionListDelegate {
    func didSelectPost(post: Post) {
        self.post = post
        setLocationOnMap(userLocation: CLLocation(latitude: post.location.latitude, longitude: post.location.longitude))
        schoolNameField.text = post.schoolName
    }
}

extension CreateEventViewController {
    // Create Date Picker and Toolbar
    func createDatePicker() {
        
        // Formatting the date picker type
        datePickerStart.datePickerMode = .date
        datePickerStart.locale = Locale(identifier: "id")
        datePickerEnd.datePickerMode = .date
        datePickerEnd.locale = Locale(identifier: "id")
        
        // Create Toolbar
        let toolbar = UIToolbar()
        let toolbar2 = UIToolbar()
        toolbar.sizeToFit()
        toolbar2.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissDatePicker))
        doneButton.tintColor = .bantuBlue
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissDatePicker2))
        doneButton2.tintColor = .bantuBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        let cancelButton2 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        cancelButton.tintColor = .bantuBlue
        cancelButton2.tintColor = .bantuBlue
        toolbar.setItems([cancelButton,flexibleSpace,doneButton], animated: false)
        toolbar2.setItems([cancelButton2,flexibleSpace2,doneButton2], animated: false)
        
        
        startDateField.inputAccessoryView = toolbar
        startDateField.inputView = datePickerStart
        endDateField.inputAccessoryView = toolbar2
        endDateField.inputView = datePickerEnd
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    // Used for Date Picker Done button
    @objc func dismissDatePicker() {
        // Format Date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy" // dd-MM-yyyy
        formatter.locale = Locale(identifier: "id")
        let date = formatter.string(from: datePickerStart.date)
        
        startDateField.text = String(date)
        view.endEditing(true)
    }
    @objc func dismissDatePicker2() {
        // Format Date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy" // dd-MM-yyyy
        formatter.locale = Locale(identifier: "id")
        let date = formatter.string(from: datePickerEnd.date)
        
        endDateField.text = String(date)
        view.endEditing(true)
    }
}
