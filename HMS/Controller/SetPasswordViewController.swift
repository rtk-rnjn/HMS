//
//  SetPasswordViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class SetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowSignInViewController", sender: nil)
    }
}
