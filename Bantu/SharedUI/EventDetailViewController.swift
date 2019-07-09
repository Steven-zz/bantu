//
//  EventDetailViewController.swift
//  Bantu
//
//  Created by Cason Kang on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit
import ImageSlideshow
import MapKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var imageSlide: ImageSlideshow!
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var budgetLbl: UILabel!
    @IBOutlet weak var volunteersNeededLbl: UILabel!
    @IBOutlet weak var aboutField: UITextView!
    @IBOutlet weak var requirementsField: UITextView!
    @IBOutlet weak var schoolLocationMapView: MKMapView!
    @IBOutlet weak var openMapsBtn: UIButton!
    @IBOutlet weak var seeMoreBtn: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contactView: UIView!
    
    let event: Event
    let userRole: User.Role
    
    init(userRole: User.Role, event: Event) {
        self.userRole = userRole
        self.event = event
        
        super.init(nibName: "EventDetailViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactBtn.buttonSecondDesign()
        openMapsBtn.buttonDesign()
        seeMoreBtn.setTitleColor(.bantuBlue, for: .normal)
        if userRole == .admin {
            contactView.isHidden = true
        }
        loadData()
        // Do any additional setup after loading the view.
    }
    
    private func loadData() {
        eventNameLbl.text = event.eventName
        dateLbl.text = "\(event.startDate) - \(event.endDate)"
        locationLbl.text = "\(event.post.location.locality), \(event.post.location.adminArea)"
        budgetLbl.text = "Rp. \(event.fee)"
        aboutField.text = event.description
        requirementsField.text = event.requirements
        volunteersNeededLbl.text = "\(event.volunteerNo) Orang"
        let loc = CLLocation(latitude: event.post.location.latitude, longitude: event.post.location.longitude)
        setLocationOnMap(userLocation: loc)
        self.activIndicator.startAnimating()
        event.imgUrl.getImageFromString { image in
            let img = ImageSource(image: image)
            DispatchQueue.main.sync {
                self.setupSlide(images: [img])
            }
        }
    }
    
    private func setupSlide(images: [ImageSource]) {
        self.imageSlide.slideshowInterval = 0
        self.imageSlide.circular = false
        self.imageSlide.zoomEnabled = true
        self.imageSlide.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        self.imageSlide.setImageInputs(images)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        self.imageSlide.addGestureRecognizer(gestureRecognizer)
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
    
    @objc func didTap() {
        self.imageSlide.presentFullScreenController(from: self)
    }

    @IBAction func seeMoreBtn(_ sender: Any) {
        let vc = SeeMoreViewController(event: event)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactBtn(_ sender: Any) {let alertController = UIAlertController(title: "Hubungi", message: "Hubungi contact person di nomor \(event.eventContactNumber.trimmingCharacters(in: .whitespacesAndNewlines))? ", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Hubungi", style: .default) { _ in
            let string = "whatsapp://send?phone=\(self.event.eventContactNumber.trimmingCharacters(in: .whitespacesAndNewlines))&text= "
            guard let url = URL(string: string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
            
            UIApplication.shared.openURL(url)
        }
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func openMaps(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { (action) in
            let url = "http://maps.apple.com/maps?saddr=&daddr=\(self.event.post.location.latitude),\(self.event.post.location.longitude)"
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
            let url = "comgooglemaps://?saddr=&daddr=\(self.event.post.location.latitude),\(self.event.post.location.longitude)&directionsmode=driving"
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
    
}
