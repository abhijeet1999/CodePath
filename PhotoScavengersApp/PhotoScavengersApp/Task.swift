//
//  Task.swift
//  PhotoScavengersApp
//
//  Created by Abhijeet Cherungottil on 8/30/25.
//

import UIKit
import PhotosUI

struct Task {
    var title: String
    var description: String
    var isComplete:Bool = false
    var image: UIImage = UIImage()
    var coordinate: CLLocation = CLLocation()
}
