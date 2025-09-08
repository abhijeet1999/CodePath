//
//  NewTaskViewController.swift
//  PhotoScavengersApp
//
//  Created by Abhijeet Cherungottil on 9/7/25.
//

import UIKit

class NewTaskViewController: UIViewController {
    var onComposeTask: ((Task) -> Void)? = nil

    @IBOutlet weak var descriptionTextView: UITextField!
    @IBOutlet weak var titleTextView: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func CancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)

    }
    @IBAction func AddButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextView.text,
              let description = descriptionTextView.text,
              !title.isEmpty,
              !description.isEmpty else {
            presentEmptyFieldsAlert()
            return
        }

        let task = Task(title: title, description: description)
        onComposeTask?(task)
        dismiss(animated: true)
    }
    private func presentEmptyFieldsAlert() {
        let alertController = UIAlertController(
            title: "Oops...",
            message: "Both title and description fields must be filled out",
            preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
}
