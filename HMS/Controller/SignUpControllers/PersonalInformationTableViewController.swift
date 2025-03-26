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

    @IBOutlet var genderButton: UIButton!
    @IBOutlet var nextButton: UIButton!

    var selectedGender: String = "Male"
    var patient: Patient?

    let newPasswordEyeButton: UIButton = .init(type: .custom)
    let confirmPasswordEyeButton: UIButton = .init(type: .custom)

    var hasValidInput: Bool {
        guard let firstName = firstNameTextField.text, let email = emailTextField.text, let newPassword = newPasswordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            return false
        }
        let hasInputs = !firstName.isEmpty && !email.isEmpty && !newPassword.isEmpty && !confirmPassword.isEmpty

        let hasValidEmail = email.isValidEmail()
        let passwordsMatch = newPassword == confirmPassword

        return hasInputs && hasValidEmail && passwordsMatch
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newPasswordTextField.configureEyeButton(with: newPasswordEyeButton)
        confirmPasswordTextField.configureEyeButton(with: confirmPasswordEyeButton)

        dateOfBirthPicker.maximumDate = Date()
        passwordEntered()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowMedicalInformationTableViewController", let medicalInformationTableViewController = segue.destination as? MedicalInformationTableViewController {
            medicalInformationTableViewController.patient = sender as? Patient
        }

        if segue.identifier == "segueShowPickerViewController", let pickerViewController = segue.destination as? PickerViewController, let presentationController = segue.destination.presentationController as? UISheetPresentationController {
            guard let (sender, options) = sender as? (UIButton, [String: String]) else { return }
            pickerViewController.options = options
            pickerViewController.completionHandler = { _, value in
                sender.setTitle(value, for: .normal)
                self.selectedGender = value
                self.nextButton.isEnabled = self.hasValidInput
            }

            presentationController.detents = [.medium()]
        }
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if validateFields() {
            performSegue(withIdentifier: "segueShowMedicalInformationTableViewController", sender: patient)
        } else {
            showAlert(message: "Please fill all the fields")
        }
    }

    @IBAction func nameEditingChaged(_ sender: UITextField) {
        firstNameTextField.text = firstNameTextField.text?.filter { $0.isLetter || $0.isWhitespace }
        lastNameTextField.text = lastNameTextField.text?.filter { $0.isLetter || $0.isWhitespace }

        firstNameTextField.text = firstNameTextField.text?.trimmingCharacters(in: .whitespaces)
        lastNameTextField.text = lastNameTextField.text?.trimmingCharacters(in: .whitespaces)
    }

    private func passwordEntered() {
        let hasSomeNewPassword = newPasswordTextField.text?.isEmpty ?? true ? false : true
        
        newPasswordEyeButton.isEnabled = hasSomeNewPassword
        newPasswordEyeButton.tintColor = hasSomeNewPassword ? .tintColor : .gray
        
        let hasSomeConfirmPassword = confirmPasswordTextField.text?.isEmpty ?? true ? false : true
        
        confirmPasswordEyeButton.isEnabled = hasSomeConfirmPassword
        confirmPasswordEyeButton.tintColor = hasSomeConfirmPassword ? .tintColor : .gray
    }
    
    @IBAction func passwordEditingChanged(_ sender: UITextField) {
        passwordEntered()
    }

    @IBAction func textEditingChanged(_ sender: UITextField) {
        nextButton.isEnabled = hasValidInput
    }

    // MARK: Private

    private func validateFields() -> Bool {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showAlert(message: "First name is required")
            return false
        }

        let lastName = lastNameTextField.text ?? ""

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

        patient = Patient(firstName: firstName, lastName: lastName, emailAddress: email, password: newPassword, dateOfBirth: dateOfBirthPicker.date, gender: gender, bloodGroup: .aNegative, height: 0, weight: 0, allergies: [], medications: [])

        return true
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true)
    }

    @IBAction func genderButtonTapped(_ sender: UIButton) {
        let options = ["": "", "Male": "Male", "Female": "Female", "Other": "Other"]
        performSegue(withIdentifier: "segueShowPickerViewController", sender: (sender, options))
    }
}
