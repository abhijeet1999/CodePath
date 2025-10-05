//
//  PostCommentViewController.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 10/4/25.
//

import UIKit
import Alamofire
import AlamofireImage
import ParseSwift

class PostCommentViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var commentTextfield: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    private var imageDataRequest: DataRequest?
    var post: Post?                // the post being viewed
    var comments: [Comment] = []   // local cache of comments
        
    override func viewDidLoad() {
            super.viewDidLoad()
            
            tableview.dataSource = self
            tableview.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
        guard let post = post else { return }
        configure(with: post)
            loadComments()
        }
        
    private func loadComments() {
        guard let post = post else { return }
        print("Querying comments for post:", post.objectId ?? "nil")

        do {
            let query = try Comment.query("post" == post) // <-- pass Post object, not objectId
                .order([.ascending("createdAt")])
                .include("user")
                .limit(10)

            query.find { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let comments):
                        self?.comments = comments
                        print("Loaded comments:", comments.count)
                        self?.tableview.reloadData()
                    case .failure(let error):
                        print("❌ Error loading comments:", error.localizedDescription)
                    }
                }
            }
        } catch {
            print("❌ Failed to create comment query:", error)
        }
    }




   
    @IBAction func submitCommentTapped(_ sender: UIButton) {
        guard let post = post,
                  let currentUser = User.current,
                  let text = commentTextfield.text,
                  !text.isEmpty else { return }

            var newComment = Comment()
            newComment.text = text
        newComment.user = currentUser
            newComment.post = post

            newComment.save { [weak self] result in
                DispatchQueue.main.async { // <-- ensure UI updates happen on main thread
                    switch result {
                    case .success:
                        print("✅ Comment saved")
                        self?.commentTextfield.text = ""   // safe now
                        self?.loadComments()               // safe now

                    case .failure(let error):
                        print("❌ Error saving comment: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func configure(with post: Post) {
        self.post = post
        
               
               if let user = post.user {
                   usernameLabel.text = user.username ?? " "
               }
               
               if let imageFile = post.imageFile,
                  let imageUrl = imageFile.url {
                   imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                       switch response.result {
                       case .success(let image):
                           self?.postImageView.image = image
                       case .failure(let error):
                           print("❌ Error fetching image: \(error.localizedDescription)")
                       }
                   }
               }
               
               captionLabel.text = post.caption
               locationLabel.text = post.location
               
               if let date = post.createdAt {
                   dateLabel.text = RelativeDateTimeFormatter().localizedString(for: date, relativeTo: Date())
               }
           }

    
}

extension PostCommentViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1   // single section
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("comment count:", comments.count)
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        let comment = comments[indexPath.row]
        let username = comment.user?.username ?? "Anonymous"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(username): \(comment.text ?? "")"
        cell.textLabel?.textColor = .label
        return cell
    }

    // MARK: - Comment Section Header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Comments"
    }

    // Optional: style the header
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .systemBlue
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
}
