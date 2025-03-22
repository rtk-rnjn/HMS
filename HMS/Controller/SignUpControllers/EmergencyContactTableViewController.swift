//
//  EmergencyContactTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class EmergencyContactTableViewController: UITableViewController {
    @IBOutlet var emergencyContactName: UITextField!
    @IBOutlet var emergencyContactNumber: UITextField!
    @IBOutlet var emergencyContactRelationship: UITextField!

    @IBAction func completeButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowInitialTabBarViewController", sender: nil)
    }
}
