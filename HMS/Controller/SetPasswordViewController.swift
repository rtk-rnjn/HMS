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
        configureEyeButton(for: confirmPasswordTextField)
        configureEyeButton(for: newPasswordTextField)
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
            guard let email else { fatalError("HOW TF EMAIL IS NONE???") }

            let changed = await DataController.shared.hardPasswordReset(emailAddress: email, password: newPassword)
            if changed {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueShowSignInViewController", sender: nil)
                }
            }

        }
    }

    // MARK: Private

    private func configureEyeButton(for textField: UITextField) {
           let eyeButton = UIButton(type: .custom)
           eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
           eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
           eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
           eyeButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

           textField.rightView = eyeButton
           textField.rightViewMode = .always
           textField.isSecureTextEntry = true // Ensure secure entry initially
       }

       @objc private func togglePasswordVisibility(_ sender: UIButton) {
           guard let textField = sender.superview as? UITextField else { return }
           sender.isSelected.toggle()
           textField.isSecureTextEntry.toggle()
       }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
