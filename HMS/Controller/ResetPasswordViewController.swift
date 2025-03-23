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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

    @IBAction func requestOTPButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        guard email.isValidEmail() else {
            showAlert(message: "Invalid email")
            return
        }
        performSegue(withIdentifier: "segueShowSetPasswordViewController", sender: nil)
    }

    // MARK: Private

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
