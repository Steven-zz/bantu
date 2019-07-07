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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        guard let about = aboutField.text, aboutField.isNotEmpty(), about.first != " " else {
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
