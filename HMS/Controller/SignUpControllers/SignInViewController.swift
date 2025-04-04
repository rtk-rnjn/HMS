//

//

//

import UIKit

class SignInViewController: UIViewController {

    // MARK: Internal

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!

    let eyeButton: UIButton = .init(type: .custom)

    var isValidEmail: Bool {
        guard let email = emailTextField.text else { return false }
        return email.isValidEmail()
    }

    var isPasswordFilled: Bool {
        guard let password = passwordTextField.text else { return false }
        return !password.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        eyeButton.tintColor = .gray
        eyeButton.isEnabled = false

        passwordTextField.configureEyeButton(with: eyeButton)

        navigationItem.hidesBackButton = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        signInButton.isEnabled = isValidEmail && isPasswordFilled
    }

    @IBAction func passwordEditingChanged(_ sender: UITextField) {
        let hasSomePassword = passwordTextField.text?.isEmpty ?? true ? false : true

        eyeButton.isEnabled = hasSomePassword
        eyeButton.tintColor = hasSomePassword ? .tintColor : .gray
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

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
