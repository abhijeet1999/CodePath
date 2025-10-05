//
//  User.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 9/23/25.
//

import UIKit
import ParseSwift

struct User: ParseUser, Codable {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var lastPostedDate: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // These are required by `ParseUser`.
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?

    // Your custom properties.
    // var customKey: String?
}
