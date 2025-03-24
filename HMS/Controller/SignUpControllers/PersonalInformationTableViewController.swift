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

    var selectedGender: String = "Male"
    var patient: Patient?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureEyeButton(for: newPasswordTextField)
        configureEyeButton(for: confirmPasswordTextField)
        dateOfBirthPicker.maximumDate = Date()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowMedicalInformationTableViewController", let medicalInformationTableViewController = segue.destination as? MedicalInformationTableViewController {
            medicalInformationTableViewController.patient = sender as? Patient
        }
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if validateFields() {
            performSegue(withIdentifier: "segueShowMedicalInformationTableViewController", sender: patient)
        } else {
            showAlert(message: "Please fill all the fields")
        }
    }

    @IBAction func genderSegmentedControlTapped(_ sender: UISegmentedControl) {
        selectedGender = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "Other"
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

        let gender = Gender(rawValue: selectedGender) ?? .other

        patient = Patient(firstName: firstName, emailAddress: email, password: newPassword, dateOfBirth: dateOfBirthPicker.date, gender: gender, bloodGroup: .aNegative, height: 0, weight: 0, allergies: [], medications: [], emergencyContactName: "", emergencyContactNumber: "", emergencyContactRelationship: "")

        return true
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true)
    }

}
