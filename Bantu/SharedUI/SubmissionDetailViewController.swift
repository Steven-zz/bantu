//
//  SubmissionDetailViewController.swift
//  Bantu
//
//  Created by Cason Kang on 06/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit
import ImageSlideshow
import MapKit
import SwiftOverlays

class SubmissionDetailViewController: UIViewController {

    @IBOutlet weak var schoolImageSlide: ImageSlideshow!
    @IBOutlet weak var schoolNameLbl: UILabel!
    @IBOutlet weak var aboutField: SecondTextView!
    @IBOutlet weak var studentNumberField: UITextView!
    @IBOutlet weak var teacherNumberField: UITextView!
    @IBOutlet weak var accessField: SecondTextView!
    @IBOutlet weak var notesField: SecondTextView!
    @IBOutlet weak var addressField: SecondTextView!
    @IBOutlet weak var schoolLocationMapView: MKMapView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var navigateBtn: UIButton!
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var acceptRejectView: UIView!
    
    let userRole: User.Role
    let post: Post
    
    init(userRole: User.Role, post: Post) {
        self.userRole = userRole
        self.post = post
        
        super.init(nibName: "SubmissionDetailViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigateBtn.buttonDesign()
        contactBtn.buttonDesign()
        rejectBtn.buttonSecondDesign()
        acceptBtn.buttonSecondDesign()
        // Do any additional setup after loading the view.
        loadData()
    }
    
    private func loadData() {
        activIndicator.startAnimating()
        
        schoolNameLbl.text = post.schoolName
        aboutField.text = post.about
        studentNumberField.text = String(post.studentNo)
        teacherNumberField.text = String(post.teacherNo)
        addressField.text = post.address
        accessField.text = post.accessNotes
        notesField.text = post.notes
        setLocationOnMap(userLocation: CLLocation(latitude: post.location.latitude, longitude: post.location.longitude))
        
        if userRole == .admin {
            acceptRejectView.isHidden = false
        }
        
//        self.downloadImages(imageLinks: self.post.schoolImages+self.post.roadImages) { images in
//            self.setupSlide(images: images)
//        }
        var images: [ImageSource] = []
        var imagesFlag: Int = 0 {
            didSet {
                let final = post.roadImages.count + post.schoolImages.count
                if imagesFlag == final {
                    DispatchQueue.main.sync {
                        self.setupSlide(images: images)
                    }
                }
            }
        }
        for x in post.roadImages {
            x.getImageFromString() { img in
                images.append(ImageSource(image: img))
                imagesFlag += 1
            }
        }
        for x in post.schoolImages {
            x.getImageFromString() { img in
                images.append(ImageSource(image: img))
                imagesFlag += 1
            }
        }
    }
    
    private func setupSlide(images: [ImageSource]) {
        self.schoolImageSlide.slideshowInterval = 0
        self.schoolImageSlide.circular = false
        self.schoolImageSlide.zoomEnabled = true
        self.schoolImageSlide.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        self.schoolImageSlide.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        self.schoolImageSlide.pageIndicator = pageControl
        self.schoolImageSlide.setImageInputs(images)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        self.schoolImageSlide.addGestureRecognizer(gestureRecognizer)
        loadingView.removeFromSuperview()
    }
    
    func setLocationOnMap(userLocation: CLLocation) {
        let annotation = MKPointAnnotation()
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        schoolLocationMapView.setRegion(region, animated: true)
        schoolLocationMapView.showsUserLocation = true
        annotation.coordinate = myLocation
        schoolLocationMapView.addAnnotation(annotation)
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Izinkan akses lokasi", message: "Aktifkan lokasi untuk mendapatkan lokasi anda", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func didTap() {
        self.schoolImageSlide.presentFullScreenController(from: self)
    }

    @IBAction func openMaps(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { (action) in
            let url = "http://maps.apple.com/maps?saddr=&daddr=\(self.post.location.latitude),\(self.post.location.longitude)"
            if UIApplication.shared.canOpenURL(NSURL(string: url)! as URL) {
                UIApplication.shared.openURL(URL(string:url)!)
            } else {
                let alert = UIAlertController(title: "Error", message: "Tolong Install Apple Maps", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { (action) in
            let url = "comgooglemaps://?saddr=&daddr=\(self.post.location.latitude),\(self.post.location.longitude)&directionsmode=driving"
            if UIApplication.shared.canOpenURL(NSURL(string: url)! as URL) {
                UIApplication.shared.openURL(URL(string:url)!)
            } else {
                let alert = UIAlertController(title: "Error", message: "Tolong Install Google Maps", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func contact(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "User", style: .default, handler: { _ in
            let string = "whatsapp://send?phone=\(self.post.user.phone.trimmingCharacters(in: .whitespacesAndNewlines))&text= "
            guard let url = URL(string: string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            } else {
                let alert = UIAlertController(title: "Error", message: "Mohon Install WhatsApp", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Contact Person Sekolah", style: .default, handler: { _ in
            let string = "whatsapp://send?phone=\(self.post.contactNumber.trimmingCharacters(in: .whitespacesAndNewlines))&text= "
            guard let url = URL(string: string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            } else {
                let alert = UIAlertController(title: "Error", message: "Mohon Install WhatsApp", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension SubmissionDetailViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                presentAlert()
            default:
                break
            }
        }
    }
}
