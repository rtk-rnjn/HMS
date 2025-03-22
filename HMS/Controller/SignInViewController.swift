//
//  SignInViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 21/03/25.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
    }

    @IBAction func createAccountTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowPersonalInformationTableViewController", sender: nil)
    }

    @IBAction func forgetPasswordTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowResetPasswordViewController", sender: nil)
    }

}
