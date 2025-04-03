//
//  ResetPasswordViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    // MARK: Internal

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var otpTextField: UITextField!
    @IBOutlet var requestContinueButton: UIButton!

    var otpRequested = false

    var isValidEmail: Bool {
        guard let email = emailTextField.text else { return false }
        return email.isValidEmail()
    }

    var isValidOtp: Bool {
        guard let otp = otpTextField.text else { return false }
        return !otp.isEmpty && otp.count == 6 && otp.allSatisfy(\.isNumber)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowSetPasswordViewController", let email = sender as? String, let setPasswordViewController = segue.destination as? SetPasswordViewController {

            setPasswordViewController.email = email
        }
    }

    @IBAction func emailEditingChanged(_ sender: UITextField) {
        requestContinueButton.isEnabled = isValidEmail
    }

    @IBAction func otpEditingChanged(_ sender: UITextField) {
        otpTextField.text = otpTextField.text?.filter { $0.isNumber }
        requestContinueButton.isEnabled = isValidOtp
    }

    @IBAction func requestOTPButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        if otpRequested {
            let otp = otpTextField.text ?? ""

            Task {
                let otpValid = await DataController.shared.verifyOtp(emailAddress: email, otp: otp)
                DispatchQueue.main.async {
                    if otpValid {
                        self.performSegue(withIdentifier: "segueShowSetPasswordViewController", sender: email)
                    } else {
                        self.showAlert(message: "Invalid OTP")
                    }
                }
            }

            return
        }

        otpRequested = true

        sender.setTitle("Continue", for: .normal)
        sender.isEnabled = false

        emailTextField.isEnabled = !isValidEmail
        otpTextField.isEnabled = true

        showAlert(error: "Success", message: "OTP has been sent to your email")

        Task {
            let otpSent = await DataController.shared.requestOtp(emailAddress: email)
            DispatchQueue.main.async {
                if !otpSent {
                    self.showAlert(error: "Error", message: "Failed to send OTP")
                }
            }
        }

    }

    // MARK: Private

    private func showAlert(error: String = "Error", message: String) {
        let alert = Utils.getAlert(title: "", message: message)
        present(alert, animated: true, completion: nil)
    }

}
