//
//  Comment.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 10/4/25.
//

import UIKit
import ParseSwift

struct Comment: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Custom fields
    var text: String?
    var user: User?          // who made the comment
    var post: Post?          // reference to which post
}
