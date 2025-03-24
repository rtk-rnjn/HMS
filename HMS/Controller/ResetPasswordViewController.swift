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

    var otpRequested = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowSetPasswordViewController" {
            guard let email = sender as? String else { return }
            guard let setPasswordViewController = segue.destination as? SetPasswordViewController else {
                fatalError("yeh dosti hum nahi todenge, todenge dum magar tera saath na chhodenge")
            }
            setPasswordViewController.email = email
        }
    }

    @IBAction func requestOTPButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        if otpRequested {
            let otp = otpTextField.text ?? ""
            guard !otp.isEmpty else {
                showAlert(message: "OTP is required")
                return
            }

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

        guard email.isValidEmail() else {
            showAlert(message: "Invalid email")
            return
        }

        otpRequested = true
        sender.setTitle("Continue", for: .normal)

        Task {
            let otpSent = await DataController.shared.requestOtp(emailAddress: email)
            DispatchQueue.main.async {
                if !otpSent {
                    self.showAlert(message: "Failed to send OTP")
                }
            }
        }

    }

    // MARK: Private

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }

}
