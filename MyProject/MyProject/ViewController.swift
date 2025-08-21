//
//  ViewController.swift
//  MyProject
//
//  Created by Abhijeet Cherungottil on 8/20/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var isCommentSwitch: UISwitch!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet var backgroundview: UIView!
    @IBOutlet weak var morePetsSwitch: UISwitch!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var schoolTextField: UITextField!
    
    @IBOutlet weak var petsStepper: UIStepper!
    @IBOutlet weak var noOfPetsLabel: UILabel!
    @IBOutlet weak var yearSegmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func moreStepperTapped(_ sender: UIStepper) {
        noOfPetsLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func moreButtonSwitchTapped(_ sender: UISwitch) {
    }
    
    @IBAction func addCommentButtonTapped(_ sender: UISwitch) {
        commentLabel.isHidden = !sender.isOn
        commentTextField.isHidden = !sender.isOn
        
    }
    @IBAction func backgroundChangeColorButtonTapped(_ sender: UISwitch) {
        backgroundview.backgroundColor = sender.isOn ? .yellow : .white
    }
    @IBAction func introduceYourselfTapped(_ sender: UIButton) {
        // Lets us choose the title we have selected from the segmented control
               // In our example that is whether it is first, second, third or forth
               let year = yearSegmentControl.titleForSegment(at: yearSegmentControl.selectedSegmentIndex)

               // Creating a constant of type string that holds an introduction. The introduction receives the values from the outlet connections.
               var introduction = "My name is \(firstNameTextField.text!) \(lastNameTextField.text!) and I attend \(schoolTextField.text!).I am currently in my \(year!) year and I own \(noOfPetsLabel.text!) dogs.It is \(morePetsSwitch.isOn) that I want more pets."
                    if(isCommentSwitch.isOn) {
                        introduction = introduction + "\n Comment added : \(commentTextField.text ?? "")"
                    }

               print(introduction)
        
        // Creates the alert where we pass in our message, which our introduction.
                let alertController = UIAlertController(title: "My Introduction", message: introduction, preferredStyle: .alert)

                // A way to dismiss the box once it pops up
                let action = UIAlertAction(title: "Nice to meet you!", style: .default, handler: nil)

                // Passing this action to the alert controller so it can be dismissed
                alertController.addAction(action)

                present(alertController, animated: true, completion: nil)
    }
}

