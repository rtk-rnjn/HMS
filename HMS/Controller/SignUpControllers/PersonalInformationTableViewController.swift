//
//  PersonalInformationTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class PersonalInformationTableViewController: UITableViewController {

    // MARK: Internal

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var dateOfBirthPicker: UIDatePicker!

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!

    var selectedGender: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        dateOfBirthPicker.maximumDate = Date()
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if validateFields() {
            performSegue(withIdentifier: "segueShowEmergencyContactTableViewController", sender: nil)
        } else {
            showAlert(message: "Please fill all the fields")
        }
    }

    @IBAction func genderSegmentedControlTapped(_ sender: UISegmentedControl) {
        selectedGender = sender.titleForSegment(at: sender.selectedSegmentIndex)
    }

    // MARK: Private

    private func validateFields() -> Bool {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showAlert(message: "First name is required")
            return false
        }

        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Email is required")
            return false
        }

        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(message: "New password is required")
            return false
        }

        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Confirm password is required")
            return false
        }

        guard newPassword == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return false
        }

        if !email.isValidEmail() {
            showAlert(message: "Invalid email")
            return false
        }

        if !newPassword.isValidPassword() {
            showAlert(message: "Invalid password. Password must be at least 8 characters long & alphanumeric")
            return false
        }

        return true
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true)
    }

}
