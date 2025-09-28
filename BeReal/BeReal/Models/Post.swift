//
//  Post.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 9/20/25.
//

import UIKit
import ParseSwift

struct Post: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var caption: String?
    var user: User?
    var imageFile: ParseFile?
    var location : String?
}
