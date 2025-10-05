//
//  HomeViewController.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 9/20/25.
//

import UIKit
import ParseSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var posts = [Post]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        queryPosts()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
  
    @IBAction func logoutButtonTapped(_ sender: Any) {
        User.logout { [weak self] result in

            switch result {
            case .success:

                // Make sure UI updates are done on main thread when initiated from background thread.
                DispatchQueue.main.async {
                    self?.showConfirmLogoutAlert()
                    
                }
            case .failure(let error):
                print("❌ Log out error: \(error)")
            }
        }
       
    }
    
    
    @IBAction func postANewPhotoTapped(_ sender: UIButton) {
        guard let detailVC = StoryBoardConstants.detail.instance.instantiateViewController(
            withIdentifier: StoryBoardIdentifiers.detailViewController) as? DetailViewController else { return }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController {
    
    private func queryPosts() {
        // Get the date for 24 hours ago
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

        // Query posts
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .where("createdAt" >= yesterdayDate) // <- Only include results created yesterday onwards
            .limit(10) // <- Limit max number of returned posts to 10                                       // limit to 20 results
        // Fetch the posts
        query.find { [weak self] (result: Result<[Post], ParseError>) in
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of your account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}


extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell else { return }

        // Only allow tap if hiddenView is hidden (i.e., not blurred)
        guard cell.hiddenView.isHidden else {
            // Optionally: show a toast/message
            print("⛔ Post is blurred, cannot view comments yet")
            return
        }

        // Navigate to comment screen
        guard let vc = StoryBoardConstants.comment.instance.instantiateViewController(
            withIdentifier: StoryBoardIdentifiers.postCommentViewController) as? PostCommentViewController else { return }
        vc.post = post
        navigationController?.pushViewController(vc, animated: true)
    }

}
