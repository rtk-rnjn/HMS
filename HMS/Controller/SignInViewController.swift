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
    @IBOutlet var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

           // Disable button initially
           signInButton.isEnabled = false
           signInButton.alpha = 0.7
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        let emailAddress = emailTextField.text ?? ""
           let password = passwordTextField.text ?? ""

           guard emailAddress.isValidEmail() else {
               showError(for: emailTextField)
               return
           }
        guard password.isValidPassword() else {
               showError(for: passwordTextField)
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

      private func showError(for textField: UITextField) {
          textField.layer.borderColor = UIColor.red.cgColor
          textField.layer.borderWidth = 1.5
          textField.layer.cornerRadius = 5
      }

      private func clearError(for textField: UITextField) {
          textField.layer.borderColor = UIColor.clear.cgColor
          textField.layer.borderWidth = 0
      }

    @objc private func textFieldDidChange() {
           let emailValid = emailTextField.text?.isValidEmail() ?? false
           let passwordValid = passwordTextField.text?.isValidPassword() ?? false

           let allFieldsValid = emailValid && passwordValid
           signInButton.isEnabled = allFieldsValid
           signInButton.alpha = allFieldsValid ? 1.0 : 0.5
       }

       func textFieldDidEndEditing(_ textField: UITextField) {
           if textField == emailTextField, !(textField.text?.isValidEmail() ?? false) {
               showError(for: textField)
           } else if textField == passwordTextField, !(textField.text?.isValidPassword() ?? false) {
               showError(for: textField)
           } else {
               clearError(for: textField)
           }
       }
}
