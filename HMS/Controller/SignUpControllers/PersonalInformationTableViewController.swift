//
//  PersonalInformationTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class PersonalInformationTableViewController: UITableViewController {
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var dateOfBirthPicker: UIDatePicker!

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowMedicalInformationTableViewController", sender: nil)
    }
}
