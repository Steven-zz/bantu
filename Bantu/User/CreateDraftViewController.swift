//
//  CreateDraftViewController.swift
//  Bantu
//
//  Created by Cason Kang on 02/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import CoreLocation
import UIKit
import MapKit

class CreateDraftViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var schoolNameField: CreateDraftFieldExtension!
    @IBOutlet weak var aboutField: PaddingTextView!
    @IBOutlet weak var studentNumberField: UITextField!
    @IBOutlet weak var teacherNumberField: UITextField!
    @IBOutlet weak var contactPhoneField: CreateDraftFieldExtension!
    @IBOutlet weak var addressField: PaddingTextView!
    @IBOutlet weak var accessField: PaddingTextView!
    @IBOutlet weak var notesField: PaddingTextView!
    @IBOutlet weak var getLocationBtn: UIButton!
    
    @IBOutlet weak var schoolLocationMapView: MKMapView!
    
    @IBOutlet weak var schoolImagesCollectionView: UICollectionView!
    @IBOutlet weak var roadImagesCollectionView: UICollectionView!
    
    var isPickingSchool: Bool = false
    var isPickingRoad: Bool = false
    
    enum State {
        case load
        case create
    }
    
    let state:State
    
    let locationManager: CLLocationManager
    var longitude: Double
    var latitude: Double
    var aoi: String
    var locationName: String
    var locality: String
    var adminArea: String
    
    var schoolImages: [UIImage]
    var roadImages: [UIImage]
    
    var schoolName: String
    var about: String
    var studentNumber: Int
    var teacherNumber: Int
    var contactPhone: String
    var address: String
    var access: String
    var notes: String
    var currentDate: String

    init(state: State) {
        
        self.locationManager = CLLocationManager()
        
        self.state = state
        
        self.latitude = -6.2
        self.longitude = 106.8
        self.aoi = "Stasiun"
        self.locationName = "Kota"
        self.locality = "Jakarta"
        self.adminArea = "JAKSS"
        
        self.schoolImages = [UIImage]()
        self.roadImages = [UIImage]()
        
        self.currentDate = "Tanggal Hari Ini"
        
        self.schoolName = "Nama SekolahKU"
        self.about = "Tentang Sekolah"
        self.studentNumber = 5
        self.teacherNumber = 10
        self.contactPhone = "+62811829991"
        self.address = "Jl AAAAA no AAA"
        self.access = "Susah banget aksesnya"
        self.notes = "CatatanKu"
        
        super.init(nibName: "CreateDraftViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.state == .load ? "Edit Draft" : "Create Draft"
        if state == .load {
            loadData()
        }
        
        getLocationBtn.buttonDesign()
        setupCollectionViews()
        
        if state == .create {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismiss(_:)))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(post(_:)))
        }
        
        
        //location
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        schoolNameField.delegate = self
    }
    
    // MARK: - Collection View
    private func setupCollectionViews() {
        schoolImagesCollectionView.delegate = self
        schoolImagesCollectionView.dataSource = self
        
        roadImagesCollectionView.delegate = self
        roadImagesCollectionView.dataSource = self
        
        schoolImagesCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageCell")
        roadImagesCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageCell")
        
        let footer = UINib(nibName: "FooterCollectionReusableView", bundle: .main)
        schoolImagesCollectionView.register(footer, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ImageFooter")
        roadImagesCollectionView.register(footer, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ImageFooter")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case schoolImagesCollectionView:
            return schoolImages.count
        case roadImagesCollectionView:
            return roadImages.count
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        switch collectionView {
        case schoolImagesCollectionView:
            cell.setImage(image: schoolImages[indexPath.row])
        case roadImagesCollectionView:
            cell.setImage(image: roadImages[indexPath.row])
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            return UICollectionReusableView()
            
        case UICollectionView.elementKindSectionFooter:
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ImageFooter", for: indexPath) as! FooterCollectionReusableView
            if collectionView == roadImagesCollectionView {
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(roadTapDetected))
                foot.addGestureRecognizer(tapGestureRecognizer)
                return foot
            } else {
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(schoolTapDetected))
                foot.addGestureRecognizer(tapGestureRecognizer)
                return foot
            }
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case schoolImagesCollectionView:
            let alertController = UIAlertController(title: "Hapus Gambar", message: "Apakah anda ingin menghapus gambar sekolah?", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Hapus", style: .destructive) { _ in
                self.schoolImages.remove(at: indexPath.row)
                self.schoolImagesCollectionView.reloadData()
            }
            let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            alertController.addAction(cancel)
            present(alertController, animated: true, completion: nil)
        case roadImagesCollectionView:
            let alertController = UIAlertController(title: "Hapus Gambar", message: "Apakah anda ingin menghapus gambar jalan?", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Hapus", style: .destructive) { _ in
                self.roadImages.remove(at: indexPath.row)
                self.roadImagesCollectionView.reloadData()
            }
            let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            alertController.addAction(cancel)
            present(alertController, animated: true, completion: nil)
        default:
            fatalError()
        }
    }
    // MARK: - buttons
    @IBAction func getLocation(_ sender: UIButton) {
        if latitude != 0.0 && longitude != 0.0 {
            let alertController = UIAlertController(title: "Perbarui Lokasi?", message: "Apakah anda ingin mengubah lokasi sekolah? Lokasi lama akan dihapus.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Hapus & Perbarui", style: .destructive) { _ in
                guard let initialLoc = self.locationManager.location else { return }
                self.latitude = initialLoc.coordinate.latitude
                self.longitude = initialLoc.coordinate.longitude
                let loc = CLLocation(latitude: self.latitude, longitude: self.longitude)
                self.fetchLocInfo(from: loc) { city, name, adminArea, aoi, error  in
                    self.locality = city ?? ""
                    self.locationName = name ?? ""
                    self.adminArea = adminArea ?? ""
                    self.aoi = aoi ?? ""
                }
                self.setLocationOnMap(userLocation: loc)
            }
            let cancel = UIAlertAction(title: "Batal", style: .cancel) { _ in
               return
            }
            alertController.addAction(defaultAction)
            alertController.addAction(cancel)
            present(alertController, animated: true, completion: nil)
        } else {
            guard let initialLoc = locationManager.location else { return }
            latitude = initialLoc.coordinate.latitude
            longitude = initialLoc.coordinate.longitude
            let loc = CLLocation(latitude: latitude, longitude: longitude)
            fetchLocInfo(from: loc) { city, name, adminArea, aoi, error  in
                self.locality = city ?? ""
                self.locationName = name ?? ""
                self.adminArea = adminArea ?? ""
                self.aoi = aoi ?? ""
            }
            setLocationOnMap(userLocation: loc)
        }
    }
    // MARK: - functions
    private func loadData() {
        aboutField.textColor = .black
        studentNumberField.textColor = .black
        teacherNumberField.textColor = .black
        contactPhoneField.textColor = .black
        addressField.textColor = .black
        accessField.textColor = .black
        notesField.textColor = .black
        
        schoolNameField.text = schoolName
        aboutField.text = about
        studentNumberField.text = String(studentNumber)
        teacherNumberField.text = String(teacherNumber)
        contactPhoneField.text = contactPhone
        addressField.text = address
        accessField.text = access
        notesField.text = notes
        setLocationOnMap(userLocation: CLLocation(latitude: latitude, longitude: longitude))
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
    
    func fetchLocInfo(from location: CLLocation, completion: @escaping (_ city: String?, _ name: String?, _ administrativeArea: String?, _ areasOfInterest: String?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.name,
                       placemarks?.first?.administrativeArea,
                       placemarks?.first?.areasOfInterest![0],
                       error)
        }
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
    
    @objc func save(_ button: UIBarButtonItem) {
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
        
        guard let studentNumber = studentNumberField.text, studentNumber != "", studentNumber.rangeOfCharacter(from: charactersetNumbers.inverted) == nil else {
            makeAlert(message: "Isi jumlah murid dengan benar")
            return
        }
        
        guard let teacherNumber = teacherNumberField.text, teacherNumber != "", teacherNumber.rangeOfCharacter(from: charactersetNumbers.inverted) == nil else {
            makeAlert(message: "Isi jumlah guru dengan benar")
            return
        }
        
        if roadImages.count == 0 || schoolImages.count == 0  {
            makeAlert(message: "Isi minimal 1 gambar untuk sekolah dan jalan")
            return
        }
        
        guard let phoneNumber = contactPhoneField.text, phoneNumber != "", phoneNumber.rangeOfCharacter(from: charactersetPhone.inverted) == nil else {
            makeAlert(message: "Isi nomor telpon dengan benar")
            return
        }
        
        guard let address = addressField.text, addressField.isNotEmpty(), address.first != " " else {
            makeAlert(message: "Isi alamat dengan benar")
            return
        }
        
        guard let access = accessField.text, accessField.isNotEmpty(), access.first != " " else {
            makeAlert(message: "Isi akses dengan benar")
            return
        }
        
        guard let notes = notesField.text, notesField.isNotEmpty(), notes.first != " " else {
            makeAlert(message: "Isi catatan dengan benar")
            return
        }
        
        let currDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: currDate)
        currentDate = dateString
        
        print("YAY")
    }
    
    @objc func dismiss(_ button: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func post(_ button: UIBarButtonItem) {
        
    }
    
    @objc func schoolTapDetected() {
        self.isPickingSchool = true
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func roadTapDetected() {
        self.isPickingRoad = true
        
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
}

extension CreateDraftViewController: CLLocationManagerDelegate {
    
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

//MARK: Extension for image picker
extension CreateDraftViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            
            guard let imageData = image.jpeg(.medium) else { return }
            guard let finalImage = UIImage(data: imageData) else { return }
            
            if (isPickingSchool == true) {
                isPickingSchool = false
                schoolImages.append(finalImage)
                let indexPath = IndexPath(row: schoolImages.count-1, section: 0)
                schoolImagesCollectionView.insertItems(at: [indexPath])
            }
            else {
                isPickingRoad = false
                roadImages.append(finalImage)
                let indexPath = IndexPath(row: roadImages.count-1, section: 0)
                roadImagesCollectionView.insertItems(at: [indexPath])
            }
        }
    }
    
}

//text field return
extension CreateDraftViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
