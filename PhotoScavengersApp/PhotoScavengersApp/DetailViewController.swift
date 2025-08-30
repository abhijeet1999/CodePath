//
//  DetailViewController.swift
//  PhotoScavengersApp
//
//  Created by Abhijeet Cherungottil on 8/30/25.
//

import UIKit

class DetailViewController: UIViewController {
    var item: Task? 
    var onSave: ((Task) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = item?.title
        view.backgroundColor = .white
        item?.isComplete = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Check if we're moving back in the navigation stack
        if self.isMovingFromParent {
            if let updatedItem = item {
                onSave?(updatedItem)
            }
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
