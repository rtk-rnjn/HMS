//
//  SignInViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 21/03/25.
//

import UIKit

class SignInViewController: UIViewController {

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
    }

    @IBAction func createAccountTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowPersonalInformationTableViewController", sender: nil)
    }
}
