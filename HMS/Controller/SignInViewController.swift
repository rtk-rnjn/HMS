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

    
    
    let eyeButton = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eyeButton.tintColor = .gray
        eyeButton.isEnabled = false
        configureEyeButton(for: passwordTextField)
        passwordTextField.addTarget(self, action: #selector(passwordEntered), for: .editingChanged)
        
        
        
        
        
        navigationItem.hidesBackButton = true
    }

    @objc func passwordEntered(sender:UITextField){
        if passwordTextField.text?.isEmpty ?? true || passwordTextField.text == "" {
            eyeButton.isEnabled = false
            eyeButton.tintColor = .gray
        }else{
            eyeButton.isEnabled = true
            eyeButton.tintColor = .tintColor
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        let emailAddress = emailTextField.text ?? ""
        guard emailAddress.isValidEmail() else {
            showAlert(message: "Invalid email")
            return
        }

        Task {
            let loginResponse = await DataController.shared.login(emailAddress: emailAddress, password: passwordTextField.text ?? "")
            DispatchQueue.main.async {
                if loginResponse {
                    self.performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
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

    private func configureEyeButton(for textField: UITextField) {
        // Create the eye button
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

        // Create a container view to add padding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        containerView.addSubview(eyeButton)

        // Adjust the button's position within the container view
        eyeButton.frame = CGRect(x: -8, y: 0, width: 30, height: 30) // Adds a 10-point margin on the right

        // Set the container view as the right view of the text field
        textField.rightView = containerView
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true // Ensure secure entry initially
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
