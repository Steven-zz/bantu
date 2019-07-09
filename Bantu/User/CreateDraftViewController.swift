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
import FirebaseStorage
import SwiftOverlays

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
    
    @IBOutlet weak var postDraftView: UIView!
    @IBOutlet weak var postDraftBtn: UIButton!
    
    enum State {
        case edit
        case create
    }
    
    var isPickingSchool: Bool = false
    var isPickingRoad: Bool = false
    
    let state:State
    
    let locationManager: CLLocationManager
    
    var schoolImages: [UIImage] = [UIImage]()
    var roadImages: [UIImage] = [UIImage]()
    let entityModel: DraftEntityModel?
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var locality: String = ""
    var locationName: String = ""
    var adminArea: String = ""
    var aoi: String = ""

    init(entityModel: DraftEntityModel? = nil) {
        self.entityModel = entityModel
        self.locationManager = CLLocationManager()
        if entityModel != nil {
            self.state = .edit
        } else {
            self.state = .create
        }
        
        super.init(nibName: "CreateDraftViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.state == .edit ? "Edit Draft" : "Create Draft"
        if state == .edit {
            loadData()
            postDraftView.isHidden = false
            postDraftBtn.buttonSecondDesign()
        }
        
        getLocationBtn.buttonDesign()
        setupCollectionViews()
        
        if state == .create {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss(_:)))
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
        
        
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
        if state == .edit {
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
    
    @IBAction func postBtn(_ sender: UIButton) {
        post()
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
        
        guard let entity = entityModel else { return }
        schoolNameField.text = entity.schoolName
        aboutField.text = entity.about
        studentNumberField.text = String(entity.studentNo)
        teacherNumberField.text = String(entity.teacherNo)
        contactPhoneField.text = entity.contactNumber
        addressField.text = entity.address
        accessField.text = entity.accessNotes
        notesField.text = entity.notes
        roadImages = entity.roadImages
        schoolImages = entity.schoolImages
        latitude = entity.locationLatitude
        longitude = entity.locationLongitude
        aoi = entity.locationAOI
        locationName = entity.locationName
        adminArea = entity.locationAdminArea
        locality = entity.locationLocality
        setLocationOnMap(userLocation: CLLocation(latitude: entity.locationLatitude, longitude: entity.locationLongitude))
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
        annotation.coordinate = myLocation
        schoolLocationMapView.addAnnotation(annotation)
    }
    
    @objc func save(_ button: UIBarButtonItem) {
        let charactersetPhone = CharacterSet(charactersIn: "+1234567890 ")
        let charactersetNumbers = CharacterSet(charactersIn: "1234567890")

        
        guard let schoolName = schoolNameField.text, schoolName != "", schoolName.first != " " else {
            makeAlert(message: "Nama sekolah tidak boleh kosong")
            return
        }
        
        guard let about = aboutField.text, aboutField.isNotEmpty, about.first != " " else {
            makeAlert(message: "Tentang harus diisi")
            return
        }
        
        guard let studentNumberString = studentNumberField.text, studentNumberString != "", studentNumberString.rangeOfCharacter(from: charactersetNumbers.inverted) == nil, let studentNumber = Int(studentNumberString) else {
            makeAlert(message: "Isi jumlah murid dengan benar")
            return
        }
        
        guard let teacherNumberString = teacherNumberField.text, teacherNumberString != "", teacherNumberString.rangeOfCharacter(from: charactersetNumbers.inverted) == nil, let teacherNumber = Int(teacherNumberString) else {
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
        
        guard let address = addressField.text, addressField.isNotEmpty, address.first != " " else {
            makeAlert(message: "Isi alamat dengan benar")
            return
        }
        
        guard let access = accessField.text, accessField.isNotEmpty, access.first != " " else {
            makeAlert(message: "Isi akses dengan benar")
            return
        }
        
        guard let notes = notesField.text, notesField.isNotEmpty, notes.first != " " else {
            makeAlert(message: "Isi catatan dengan benar")
            return
        }
        
        if latitude == 0.0 || longitude == 0.0 {
            makeAlert(message: "Dapatkan Lokasi")
            return
        }
        
        let currDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: currDate)
        
        let draft = DraftEntityModel(timeStamp: dateString,
                                          schoolName: schoolName,
                                          about: about,
                                          studentNo: studentNumber,
                                          teacherNo: teacherNumber,
                                          address: address,
                                          accessNotes: access,
                                          notes: notes,
                                          contactNumber: phoneNumber,
                                          locationAOI: aoi,
                                          locationName: locationName,
                                          locationLocality: locality,
                                          locationAdminArea: adminArea,
                                          locationLatitude: latitude,
                                          locationLongitude: longitude,
                                          roadImages: roadImages,
                                          schoolImages: schoolImages
        )
        if state == .create {
            LocalServices.saveToDraft(draft: draft)
            self.dismiss(animated: true)
        } else {
            // update
            guard let name = entityModel?.schoolName else { return }
            LocalServices.updateFromCoreData(withSchoolName: name, updatedDraft: draft)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    @objc func dismiss(_ button: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        guard let user = GlobalSession.currentUser else {
            makeAlert(message: "Anda harus login sebelum membuat post")
            return
        }
        let alertController = UIAlertController(title: "Buat Post", message: "Apakah anda ingin membuat post?", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Buat", style: .default) { _ in
            self.uploadPost(user: user)
        }
        let cancel = UIAlertAction(title: "Batal", style: .default) { _ in
            return
        }
        alertController.addAction(cancel)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func uploadPost(user: User) {
        SwiftOverlays.showBlockingWaitOverlayWithText("Mengunggah Post")
        let currDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: currDate)
        
        var schoolUrls: [String] = []
        var roadUrls: [String] = []
        
        var imagesFlag: Int = 0 {
            didSet {
                let final: Int = roadImages.count + schoolImages.count
                if imagesFlag == final {
                    print(imagesFlag)
                    guard let draft = entityModel else {
                        SwiftOverlays.removeAllBlockingOverlays()
                        makeAlert(message: "Terjadi error saat mengunggah draft")
                        return
                    }
                    
                    let location = Location(areaOfInterest: aoi,
                                            name: locationName,
                                            locality: locality,
                                            adminArea: adminArea,
                                            latitude: latitude,
                                            longitude: longitude)
                    
                    let post = Post(postID: 0,
                                    statusID: 3,
                                    timeStamp: dateString,
                                    schoolName: draft.schoolName,
                                    about: draft.about,
                                    teacherNo: draft.teacherNo,
                                    studentNo: draft.studentNo,
                                    address: draft.address,
                                    accessNotes: draft.accessNotes,
                                    notes: draft.notes,
                                    contactNumber: draft.contactNumber,
                                    roadImages: roadUrls,
                                    schoolImages: schoolUrls,
                                    location: location,
                                    user: user)
                    PostServices.submitPost(post: post) { isSuccess in
                        LocalServices.deleteFromCoreData(withSchoolName: draft.schoolName)
                        SwiftOverlays.removeAllBlockingOverlays()
                        let alertController = UIAlertController(title: "Sukses", message: "Berhasil membuat post", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
        for image in schoolImages {
            let tempPicId = "pic-\(UUID().uuidString)"
            
            guard let data = image.jpegData(compressionQuality: 0.1) else {
                SwiftOverlays.removeAllBlockingOverlays()
                makeAlert(message: "Gagal mengunggah")
                return
            }
            let tempRef = FirebaseReferences.storageRef.child("Posts/\(user.userID)/\(dateString)/\(tempPicId).jpeg")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            let _ = tempRef.putData(data, metadata: metadata) { (metadata, error) in
                if error != nil{
                    SwiftOverlays.removeAllBlockingOverlays()
                    print("ERROR - \(error?.localizedDescription)")
                    return
                }
                print("success upload to storage")
                // You can also access to download URL after upload.
                tempRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    schoolUrls.append(downloadURL.absoluteString)
                    imagesFlag += 1
                }
            }
        }
        
        for image in roadImages {
            let tempPicId = "pic-\(UUID().uuidString)"
            
            guard let data = image.jpegData(compressionQuality: 0.1) else {
                SwiftOverlays.removeAllBlockingOverlays()
                makeAlert(message: "Gagal mengunggah")
                return
            }
            let tempRef = FirebaseReferences.storageRef.child("Posts/\(user.userID)/\(dateString)/\(tempPicId).jpeg")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            let _ = tempRef.putData(data, metadata: metadata) { (metadata, error) in
                if error != nil{
                    SwiftOverlays.removeAllBlockingOverlays()
                    print("ERROR - \(error?.localizedDescription)")
                    return
                }
                print("success upload to storage")
                // You can also access to download URL after upload.
                tempRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    roadUrls.append(downloadURL.absoluteString)
                    imagesFlag += 1
                }
            }
        }
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
            
            guard let imageData = image.jpeg(.low) else { return }
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
