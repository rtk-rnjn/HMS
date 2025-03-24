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

    // Warning labels for name fields
    private let firstNameWarningLabel = UILabel()
    private let lastNameWarningLabel = UILabel()

    var selectedGender: String = "Male"
    var patient: Patient?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureEyeButton(for: newPasswordTextField)
        configureEyeButton(for: confirmPasswordTextField)
        dateOfBirthPicker.maximumDate = Date()
        
        // Configure text fields to capitalize first letter
        firstNameTextField.autocapitalizationType = .words
        lastNameTextField.autocapitalizationType = .words
        
        // Setup warning labels
        setupWarningLabels()
        
        // Add text field delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        // Add text change observers
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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

    private func setupWarningLabels() {
        // Configure first name warning label
        firstNameWarningLabel.textColor = .red
        firstNameWarningLabel.font = .systemFont(ofSize: 12)
        firstNameWarningLabel.numberOfLines = 0
        firstNameWarningLabel.isHidden = true
        
        // Configure last name warning label
        lastNameWarningLabel.textColor = .red
        lastNameWarningLabel.font = .systemFont(ofSize: 12)
        lastNameWarningLabel.numberOfLines = 0
        lastNameWarningLabel.isHidden = true
        
        // Add warning labels to the view
        if let firstNameCell = firstNameTextField.superview?.superview as? UITableViewCell {
            firstNameCell.contentView.addSubview(firstNameWarningLabel)
            firstNameWarningLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                firstNameWarningLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 4),
                firstNameWarningLabel.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
                firstNameWarningLabel.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
                firstNameWarningLabel.bottomAnchor.constraint(lessThanOrEqualTo: firstNameCell.contentView.bottomAnchor, constant: -4)
            ])
        }
        
        if let lastNameCell = lastNameTextField.superview?.superview as? UITableViewCell {
            lastNameCell.contentView.addSubview(lastNameWarningLabel)
            lastNameWarningLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                lastNameWarningLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 4),
                lastNameWarningLabel.leadingAnchor.constraint(equalTo: lastNameTextField.leadingAnchor),
                lastNameWarningLabel.trailingAnchor.constraint(equalTo: lastNameTextField.trailingAnchor),
                lastNameWarningLabel.bottomAnchor.constraint(lessThanOrEqualTo: lastNameCell.contentView.bottomAnchor, constant: -4)
            ])
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        validateNameField(textField)
    }
    
    private func validateNameField(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        let warningLabel = textField == firstNameTextField ? firstNameWarningLabel : lastNameWarningLabel
        
        // Check for numbers and special characters
        let nameRegex = "^[a-zA-Z ]*$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValid = namePredicate.evaluate(with: text)
        
        if !text.isEmpty && !isValid {
            warningLabel.text = "Only letters are allowed"
            warningLabel.isHidden = false
            
            // Adjust cell height to accommodate warning label
            if let cell = textField.superview?.superview as? UITableViewCell {
                UIView.animate(withDuration: 0.3) {
                    cell.layoutIfNeeded()
                }
            }
        } else {
            warningLabel.isHidden = true
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    private func validateFields() -> Bool {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showAlert(message: "First name is required")
            return false
        }
        
        // Validate first name format
        let nameRegex = "^[a-zA-Z ]*$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        
        if !namePredicate.evaluate(with: firstName) {
            showAlert(message: "First name should only contain letters")
            return false
        }

        let lastName = lastNameTextField.text ?? ""
        
        // Validate last name format if not empty
        if !lastName.isEmpty && !namePredicate.evaluate(with: lastName) {
            showAlert(message: "Last name should only contain letters")
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

        patient = Patient(firstName: firstName, lastName: lastName, emailAddress: email, password: newPassword, dateOfBirth: dateOfBirthPicker.date, gender: gender, bloodGroup: .aNegative, height: 0, weight: 0, allergies: [], medications: [], emergencyContactName: "", emergencyContactNumber: "", emergencyContactRelationship: "")

        return true
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true)
    }

}

// MARK: - UITextFieldDelegate
extension PersonalInformationTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow backspace
        if string.isEmpty {
            return true
        }
        
        // Only allow letters and spaces
        let allowedCharacters = CharacterSet.letters.union(.whitespaces)
        return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }
}
