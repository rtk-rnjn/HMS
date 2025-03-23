//
//  SignInViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 21/03/25.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: Internal

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        let emailAddress = emailTextField.text ?? ""
        guard emailAddress.isValidEmail() else {
            showAlert(message: "Invalid email")
            return
        }

        Task {
            let loginResponse = await DataController.shared.login(emailAddress: emailAddress, password: passwordTextField.text ?? "")
            DispatchQueue.main.async {
                if loginResponse {
                    self.performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
                } else {
                    self.showAlert(message: "Invalid email or password")
                }
            }
        }
    }

    @IBAction func createAccountTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowPersonalInformationTableViewController", sender: nil)
    }

    @IBAction func forgetPasswordTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowResetPasswordViewController", sender: nil)
    }

    // MARK: Private

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
