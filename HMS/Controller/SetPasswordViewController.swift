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
    @IBOutlet weak var doneButton: UIButton!
    
    
    let eyeButton1 = UIButton(type: .custom)
    let eyeButton2 = UIButton(type: .custom)
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        admin = DataController.shared.admin
        eyeButton1.tintColor = .gray
        eyeButton2.tintColor = .gray
        eyeButton1.isEnabled = false
        eyeButton2.isEnabled = false
        eyeButton1.tag = 10
        configureEyeButton(for: newPasswordTextField,button: eyeButton1)
        configureEyeButton(for: confirmPasswordTextField,button: eyeButton2)
        newPasswordTextField.addTarget(self, action: #selector(passwordEntered), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(passwordEnteredForCnfrmPass), for: .editingChanged)
        
        
        
        newPasswordTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
            confirmPasswordTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)

        doneButton.isEnabled = false
        doneButton.alpha = 0.5 //
        
        
        
        navigationItem.hidesBackButton = true
    }
    
    
    
    @objc func textFieldsChanged() {
        let password = newPasswordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        
        let isValid = password.count >= 8 && confirmPassword.count >= 8 && password == confirmPassword
        
        doneButton.isEnabled = isValid
        doneButton.alpha = isValid ? 1.0 : 0.7 // Adjusted opacity for better visibility
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

    @objc func passwordEntered(sender:UITextField){
        if newPasswordTextField.text?.isEmpty ?? true || newPasswordTextField.text == "" {
            eyeButton1.isEnabled = false
            eyeButton1.tintColor = .gray
        }else{
            eyeButton1.isEnabled = true
            eyeButton1.tintColor = .tintColor
        }
    }
    
    @objc func passwordEnteredForCnfrmPass(sender:UITextField){
        if confirmPasswordTextField.text?.isEmpty ?? true || confirmPasswordTextField.text == "" {
            eyeButton2.isEnabled = false
            eyeButton2.tintColor = .gray
        }else{
            eyeButton2.isEnabled = true
            eyeButton2.tintColor = .tintColor
        }
    }
    
    private func configureEyeButton(for textField: UITextField,button:UIButton) {
        // Create the eye button
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

        // Create a container view to add padding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        containerView.addSubview(button)

        // Adjust the button's position within the container view
        button.frame = CGRect(x: -8, y: 0, width: 30, height: 30) // Adds a 10-point margin on the right

        // Set the container view as the right view of the text field
        textField.rightView = containerView
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true // Ensure secure entry initially
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.tag == 10{
            newPasswordTextField.isSecureTextEntry.toggle()
        }
        else{
            confirmPasswordTextField.isSecureTextEntry.toggle()
        }
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
