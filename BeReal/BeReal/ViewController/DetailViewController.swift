//
//  DetailViewController.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 9/21/25.
//

import UIKit
import PhotosUI
import ParseSwift
import CoreLocation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var captionTextfield: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    var pickedImage:UIImage?
    var coordinates: CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func attachAPhotoTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Photo", message: "Choose a source", preferredStyle: .actionSheet)
        
        // Camera option
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                picker.allowsEditing = false
                self.locationManager.startUpdatingLocation()
                self.present(picker, animated: true)
            })
        }
        
        // Photo library option
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            config.filter = .images
            config.selectionLimit = 1
            config.preferredAssetRepresentationMode = .current
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
        
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        
        guard let image = pickedImage,
                  let imageData = image.jpegData(compressionQuality: 0.1),
                  let coordinates = coordinates else {
                return
            }

            let uniqueName = UUID().uuidString + ".jpg"
            let imageFile = ParseFile(name: uniqueName, data: imageData)
            
            var post = Post()
            post.imageFile = imageFile
            post.caption = captionTextfield.text
            post.user = User.current
            
            // ✅ No need to set post.createdAt manually, Parse handles this.

            // Save only after resolving location
            getLocation(coordinates: coordinates) { [weak self] locationName in
                guard let self = self else { return }
                post.location = locationName

                post.save { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let post):
                            print("✅ Post Saved! \(post)")

                            // Update the user’s lastPostedDate
                            if var currentUser = User.current {
                                currentUser.lastPostedDate = Date()
                                currentUser.ACL = ParseACL()
                                currentUser.ACL?.publicRead = true
                                currentUser.save { saveResult in
                                    DispatchQueue.main.async {
                                        switch saveResult {
                                        case .success(let user):
                                            print("✅ User updated: \(user)")
                                            self.navigationController?.popViewController(animated: true)

                                        case .failure(let error):
                                            self.showAlert(description: error.localizedDescription)
                                        }
                                    }
                                }
                            }

                        case .failure(let error):
                            self.showAlert(description: error.localizedDescription)
                        }
                    }
                }
            }
        
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    /// ✅ Fixed version: completion-based geocoding
    func getLocation(coordinates: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placeMark = placemarks?.first else {
                completion(nil)
                return
            }
            
            // You can customize what you want to return
            if let name = placeMark.name {
                completion(name)
            }
            //                 else if let city = placeMark.locality {
            //                    completion(city)
            //                } else if let country = placeMark.country {
            //                    completion(country)
            //                }
            else {
                completion(nil)
            }
        }
    }
}

extension DetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        // Load UIImage
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
            guard let self = self,
                  let image = reading as? UIImage,
                  error == nil else { return }
            
            DispatchQueue.main.async {
                self.photoImageView?.image = image
                self.pickedImage = image
            }
        }
        
        // Load metadata (location)
        guard let assetId = result.assetIdentifier,
              let location = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).firstObject?.location else {
            print("⚠️ No assetIdentifier — probably an edited or iCloud-only image.")
            return
        }
        print(location.coordinate)
        DispatchQueue.main.async {
            self.coordinates = location.coordinate
            
            
        }
        
        
    }
}

// MARK: - UIImagePicker Delegate & CLLocation
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            photoImageView.image = image
            pickedImage = image
        }
        // Stop updating location after getting coordinates
        locationManager.stopUpdatingLocation()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinates = locations.last?.coordinate
        print("Device location: \(coordinates!)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get device location: \(error.localizedDescription)")
    }
}
