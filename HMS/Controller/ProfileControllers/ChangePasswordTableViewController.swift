//

//

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
        // Validate old password
        guard let oldPassword = oldPasswordTextField.text, !oldPassword.isEmpty else {
            showAlert(title: "Validation Error", message: "Please enter your current password")
            return
        }

        // Validate new password
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(title: "Validation Error", message: "Please enter a new password")
            return
        }

        // Validate confirm password
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(title: "Validation Error", message: "Please confirm your new password")
            return
        }

        // Check if passwords match
        guard newPassword == confirmPassword else {
            showAlert(title: "Validation Error", message: "New passwords do not match")
            return
        }

        // Check password requirements
        if !newPassword.isValidPassword() {
            showAlert(title: "Invalid Password", message: "Password must be at least 8 characters long and contain both letters and numbers")
            return
        }

        // Check if new password is different from old password
        if oldPassword == newPassword {
            showAlert(title: "Invalid Password", message: "New password must be different from your current password")
            return
        }

        // Validate current password
        guard let storedPassword = UserDefaults.standard.string(forKey: "password"),
              oldPassword == storedPassword else {
            showAlert(title: "Invalid Password", message: "Current password is incorrect")
            return
        }

        // Show loading indicator
        let loadingAlert = UIAlertController(title: nil, message: "Changing password...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        loadingAlert.view.addSubview(loadingIndicator)
        present(loadingAlert, animated: true)

        Task {
            let changed = await DataController.shared.changePassword(oldPassword: oldPassword, newPassword: newPassword)

            await MainActor.run {
                // Dismiss loading indicator
                loadingAlert.dismiss(animated: true) {
                    if changed {
                        // Show success alert
                        let alert = UIAlertController(title: "Success", message: "Your password has been changed successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            self.dismiss(animated: true)
                        })
                        self.present(alert, animated: true)
                    } else {
                        // Show error alert
                        self.showAlert(title: "Error", message: "Failed to change password. Please check your current password and try again.")
                    }
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
        textField.isSecureTextEntry = true
    }

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        guard let textField = sender.superview as? UITextField else { return }
        sender.isSelected.toggle()
        textField.isSecureTextEntry.toggle()
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
