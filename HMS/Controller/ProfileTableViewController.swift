//
//  ProfileTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet var dateOfBirthLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var patientIdLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var bloodTypeLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var alergiesLabel: UILabel!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowChangePasswordTableViewController", let destination = segue.destination as? UINavigationController, let _ = destination.topViewController as? ChangePasswordTableViewController, let presentationController = segue.destination.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
    }

    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowChangePasswordTableViewController", sender: nil)
    }

}
