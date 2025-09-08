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
        Task(title: "Test 1", description: "Where do you want to go to be one with nature ?"),
        Task(title: "Test 2", description: "Where do you want to go to be one with nature ?"),
        Task(title: "Test 3", description: "Where do you want to go to be one with nature ?"),
        Task(title: "Test 4", description: "Where do you want to go to be one with nature ?")
    
    ]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Photo Scavenger Hunt"
        scavengerTableView.delegate = self
        scavengerTableView.dataSource = self
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // This will reload data in order to reflect any changes made to a task after returning from the detail screen.
        scavengerTableView.reloadData()
    }
    


    @IBAction func AddTask(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "NewTask", bundle: nil)
        guard let detailVC  = storyboard.instantiateViewController(withIdentifier: "NewTaskViewController") as? NewTaskViewController else { return }
        detailVC.onComposeTask = { [weak self] updatedItem in
            self?.data.append(updatedItem)
            DispatchQueue.main.async {
                    self?.scavengerTableView.reloadData()
                }
           }
        present(detailVC, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("table tapped")
        let storyboard = UIStoryboard(name: "DetailView", bundle: nil)
        guard let detailVC  = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
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

