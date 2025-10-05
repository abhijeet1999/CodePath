//
//  PostTableViewCell.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 9/27/25.
//

import UIKit
import Alamofire
import AlamofireImage

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    private var imageDataRequest: DataRequest?
    private var blurEffectView: UIVisualEffectView?
    
    override func awakeFromNib() {
         super.awakeFromNib()

         // Add blur effect to hiddenView
         let blurEffect = UIBlurEffect(style: .dark) // .light, .extraLight, .systemMaterial also available
         let blurView = UIVisualEffectView(effect: blurEffect)
         blurView.frame = hiddenView.bounds
         blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // resize with hiddenView

         hiddenView.addSubview(blurView)
         blurEffectView = blurView
     }

    
    func configure(with post: Post) {
        // TODO: Pt 1 - Configure Post Cell
        if let user = post.user {
            print(user)
            usernameLabel.text = user.username
        }
        
        if let currentUser = User.current,

            // Get the date the user last shared a post (cast to Date).
           let lastPostedDate = currentUser.lastPostedDate,

            // Get the date the given post was created.
           let postCreatedDate = post.createdAt,

            // Get the difference in hours between when the given post was created and the current user last posted.
           let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {

            // Hide the blur view if the given post was created within 24 hours of the current user's last post. (before or after)
            hiddenView.isHidden = abs(diffHours) < 24
        } else {

            // Default to blur if we can't get or compute the date's above for some reason.
            hiddenView.isHidden = false
        }

        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }

        // Caption
        captionLabel.text = post.caption
        locationLabel.text = post.location

        // Date
        if let date = post.createdAt {
            dateLabel.text = RelativeDateTimeFormatter().localizedString(for: date, relativeTo: Date())
        }

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO: P1 - Cancel image download
        // Reset image view image.
        postImageView.image = nil

        // Cancel image request.
        imageDataRequest?.cancel()

    }

}


