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
    @IBOutlet var doneButton: UIButton!

    let newPasswordEyeButton: UIButton = .init(type: .custom)
    let confirmPasswordEyeButton: UIButton = .init(type: .custom)

    var validInputs: Bool {
        guard let newPassword = newPasswordTextField.text, let confirmPassword = confirmPasswordTextField.text else { return false }
        return !newPassword.isEmpty && !confirmPassword.isEmpty && newPassword == confirmPassword
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        newPasswordTextField.configureEyeButton(with: newPasswordEyeButton)
        confirmPasswordTextField.configureEyeButton(with: confirmPasswordEyeButton)

        navigationItem.hidesBackButton = true
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        let newPassword = newPasswordTextField.text ?? ""

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

    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        doneButton.isEnabled = validInputs

        let hasSomeNewPassword = newPasswordTextField.text?.isEmpty ?? true ? false : true

        newPasswordEyeButton.isEnabled = hasSomeNewPassword
        newPasswordEyeButton.tintColor = hasSomeNewPassword ? .tintColor : .gray

        let hasSomeConfirmPassword = confirmPasswordTextField.text?.isEmpty ?? true ? false : true

        confirmPasswordEyeButton.isEnabled = hasSomeConfirmPassword
        confirmPasswordEyeButton.tintColor = hasSomeConfirmPassword ? .tintColor : .gray
    }

    // MARK: Private

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }

}
