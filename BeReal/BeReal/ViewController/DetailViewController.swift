//
//  DetailViewController.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 9/21/25.
//

import UIKit
import PhotosUI
import ParseSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var captionTextfield: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    weak var pickedImage:UIImage?
    var coordinates: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func attachAPhotoTapped(_ sender: UIButton) {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        
        // Set the filter to only show images as options (i.e. no videos, etc.).
        config.filter = .images
        
        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current
        
        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1
        
        // Instantiate a picker, passing in the configuration.
        let picker = PHPickerViewController(configuration: config)
        
        // Set the picker delegate so we can receive whatever image the user picks.
        picker.delegate = self
        
        // Present the picker.
        present(picker, animated: true)
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
            post.createdAt = Date()

            // ✅ Save only after we resolve location
            getLocation(coordinates: coordinates) { [weak self] locationName in
                post.location = locationName

                post.save { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let post):
                            print("✅ Post Saved! \(post)")
                            self?.navigationController?.popViewController(animated: true)
                        case .failure(let error):
                            self?.showAlert(description: error.localizedDescription)
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
