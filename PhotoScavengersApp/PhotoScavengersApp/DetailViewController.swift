//
//  DetailViewController.swift
//  PhotoScavengersApp
//
//  Created by Abhijeet Cherungottil on 8/30/25.
//

import UIKit
import MapKit
import PhotosUI

class DetailViewController: UIViewController {
    var item: Task? 
    var onSave: ((Task) -> Void)?
    @IBOutlet weak var attachImageButton: UIButton!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
  
    
    @IBOutlet weak var detailmapkit: MKMapView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = item?.title
        view.backgroundColor = .white
        guard let item = item else { return }
        updateView(item: item)
        updateMapView()
               
        detailmapkit.delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Check if we're moving back in the navigation stack
        if self.isMovingFromParent {
            if let updatedItem = item {
                onSave?(updatedItem)
            }
        }

    }
    
    @IBAction func ImagePickerButtomTapped(_ sender: UIButton) {
        // Create a configuration object
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    fileprivate func updateView(item: Task) {
        titleLabel.text = item.title
        
        detailImageView.image = item.isComplete ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        detailImageView.tintColor = item.isComplete ? UIColor.green : UIColor.red
        attachImageButton.isHidden = item.isComplete
    }

}
extension DetailViewController: MKMapViewDelegate {
    func updateMapView() {
        if item?.isComplete ?? false == true {
            guard let coordinate = item?.coordinate.coordinate else { return }
               
               // Set region
               let region = MKCoordinateRegion(
                   center: coordinate,
                   latitudinalMeters: 1000,
                   longitudinalMeters: 1000
               )
               detailmapkit.setRegion(region, animated: true)
               
               // Remove old annotations
               detailmapkit.removeAnnotations(detailmapkit.annotations)
               
               // Add new annotation
               let annotation = MKPointAnnotation()
               annotation.coordinate = coordinate
               annotation.title = item?.title ?? "Selected Location"
               detailmapkit.addAnnotation(annotation)
              
               guard let item = item else { return }
               updateView(item: item)
        }
       
           
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
          
        if annotation is MKUserLocation { return nil }
            
            let identifier = "CustomPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            // Set your picked image (or a fallback)
  
        annotationView?.image = item?.image.resized(to: CGSize(width: 40, height: 40))  ?? UIImage(systemName: "mappin.circle.fill")
            
            return annotationView

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
                self.item?.image = image
         
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
            self.item?.coordinate = location
            self.item?.isComplete = true
            self.updateMapView()
     
        }
       
       
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
