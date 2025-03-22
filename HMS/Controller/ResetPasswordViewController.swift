//
//  ResetPasswordViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

    @IBAction func requestOTPButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowSetPasswordViewController", sender: nil)
    }
}
