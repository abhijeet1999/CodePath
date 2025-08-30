//
//  ViewController.swift
//  PhotoScavengersApp
//
//  Created by Abhijeet Cherungottil on 8/30/25.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var scavengerTableView: UITableView!
    private var data = [
        Task(title: "Test 1"),
        Task(title: "Test 2"),
        Task(title: "Test 3"),
        Task(title: "Test 4")
    
    ]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Photo Scavenger Hunt"
     
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("table tapped")
        let detailVC = DetailViewController()
        detailVC.item = data[indexPath.row] // pass selected model
        detailVC.onSave = { [weak self] updatedItem in
               self?.data[indexPath.row] = updatedItem
               self?.scavengerTableView.reloadRows(at: [indexPath], with: .automatic)
           }
        navigationController?.pushViewController(detailVC, animated: true)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkedcell", for: indexPath) as! TaskTableViewCell
        cell.taskLabel.text = data[indexPath.row].title
        cell.taskImageView.image = data[indexPath.row].isComplete ?UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        cell.taskImageView.tintColor = data[indexPath.row].isComplete ? UIColor.green : UIColor.red
        
        return cell;
    }
    
    
}

