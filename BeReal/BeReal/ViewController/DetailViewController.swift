import UIKit
import PhotosUI
import ParseSwift
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var captionTextfield: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    var pickedImage: UIImage?           // Make this strong
    var coordinates: CLLocationCoordinate2D?
    
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request location permission
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func attachAPhotoTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Photo", message: "Choose a source", preferredStyle: .actionSheet)
        
        // Camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                picker.allowsEditing = false
                
                // Start location updates only for camera
                self.locationManager.startUpdatingLocation()
                
                self.present(picker, animated: true)
            })
        }
        
        // Photo library
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            config.filter = .images
            config.selectionLimit = 1
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        guard let image = pickedImage,
              let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        
        let uniqueName = UUID().uuidString + ".jpg"
        let imageFile = ParseFile(name: uniqueName, data: imageData)
        
        var post = Post()
        post.imageFile = imageFile
        post.caption = captionTextfield.text
        post.user = User.current
        
        // Use device coordinates if available
        if let coords = coordinates {
            getLocation(coordinates: coords) { locationName in
                post.location = locationName
                self.savePost(post)
            }
        } else {
            savePost(post)
        }
    }
    
    private func savePost(_ post: Post) {
        post.save { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post saved: \(post)")
                    
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
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self.showAlert(description: error.localizedDescription)
                }
            }
        }
    }

    private func showAlert(description: String? = nil) {
        let alert = UIAlertController(title: "Oops...", message: description ?? "Please try again...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func getLocation(coordinates: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                completion(placemark.name ?? "\(placemark.locality ?? "")")
            } else {
                completion(nil)
            }
        }
    }
}

// MARK: - PHPicker Delegate
extension DetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
            guard let self = self, let image = reading as? UIImage, error == nil else { return }
            DispatchQueue.main.async {
                self.photoImageView.image = image
                self.pickedImage = image
            }
        }

        // Fetch asset location if available
        if let assetId = result.assetIdentifier {
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
            if let asset = assets.firstObject, let loc = asset.location {
                self.coordinates = loc.coordinate
            }
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
