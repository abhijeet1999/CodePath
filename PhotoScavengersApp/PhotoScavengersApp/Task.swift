//
//  Task.swift
//  PhotoScavengersApp
//
//  Created by Abhijeet Cherungottil on 8/30/25.
//

import UIKit
import PhotosUI

struct Task {
    let title: String
    var isComplete:Bool = false
    var image: UIImage = UIImage()
    var coordinate: CLLocation = CLLocation()
}
