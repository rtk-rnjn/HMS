//
//  ChangePasswordTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class ChangePasswordTableViewController: UITableViewController {

    // MARK: Internal

    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureEyeButton(for: oldPasswordTextField)
        configureEyeButton(for: newPasswordTextField)
        configureEyeButton(for: confirmPasswordTextField)
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        guard let oldPassword = oldPasswordTextField.text, !oldPassword.isEmpty else {
            showAlert(message: "Old password is required")
            return
        }

        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(message: "New password is required")
            return
        }

        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Confirm password is required")
            return
        }

        guard newPassword == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return
        }

        if !newPassword.isValidPassword() {
            showAlert(message: "Password must be at least 8 characters long & alphanumeric")
            return
        }

        Task {
            let changed = await DataController.shared.changePassword(oldPassword: oldPassword, newPassword: newPassword)
            DispatchQueue.main.async {
                if changed {
                    self.dismiss(animated: true)
                } else {
                    self.showAlert(message: "Failed to change password")
                }
            }
        }
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
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
