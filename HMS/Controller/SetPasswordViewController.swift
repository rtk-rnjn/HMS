//
//  SetPasswordViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class SetPasswordViewController: UIViewController {

    // MARK: Internal

    var email: String?

    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        let newPassword = newPasswordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""

        guard !newPassword.isEmpty else {
            showAlert(message: "New password is required")
            return
        }

        guard !confirmPassword.isEmpty else {
            showAlert(message: "Confirm password is required")
            return
        }

        guard newPassword == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return
        }

        if !newPassword.isValidPassword() {
            showAlert(message: "Password must contain at least 8 characters & alphanumeric")
            return
        }

        Task {
            guard let email else { fatalError("Email is none. Cannot reset password") }

            let changed = await DataController.shared.hardPasswordReset(emailAddress: email, password: newPassword)
            if changed {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueShowSignInViewController", sender: nil)
                }
            }

        }
    }

    // MARK: Private

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
