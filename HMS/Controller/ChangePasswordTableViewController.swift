//
//  ChangePasswordTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class ChangePasswordTableViewController: UITableViewController {
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            print("Password changed successfully")
        }
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
