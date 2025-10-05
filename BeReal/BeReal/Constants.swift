//
//  Constants.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 9/20/25.
//

import UIKit

enum StoryBoardConstants: String {
    case main = "Main"
    case signUo = "Signup"
    case home = "Home"
    case detail = "Detail"
    case comment = "Comment"


    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

enum StoryBoardIdentifiers {
    static let viewController = "ViewController"
    static let signUpViewController = "SignUpViewController"
    static let homeViewController = "HomeViewController"
    static let detailViewController = "DetailViewController"
    static let postCommentViewController = "PostCommentViewController"

}
