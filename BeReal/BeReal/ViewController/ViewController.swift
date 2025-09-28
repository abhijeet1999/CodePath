//
//  ViewController.swift
//  BeReal
//
//  Created by Abhijeet Cherungottil on 9/20/25.
//

import UIKit
import ParseSwift

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    


    @IBAction func loginbuttonTapped(_ sender: UIButton) {
    
            guard let username = usernameTextfield.text,
                  let password = passwordTextfield.text,
                  !username.isEmpty,
                  !password.isEmpty
        else { showMissingFieldsAlert()
                return }
        
        User.login(username: username, password: password) { [weak self] result in

            switch result {
            case .success(let user):
                print("✅ Successfully logged in as user: \(user)")
                UserAuthenticator().setUserRegister(user)
                // Post a notification that the user has successfully logged in.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let signupVC = StoryBoardConstants.signUo.instance.instantiateViewController(
            withIdentifier: StoryBoardIdentifiers.signUpViewController) as? SignUpViewController else { return }
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    
    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Sign Up", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to sign you up.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }


    
}
