//
//  EmergencyContactTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class EmergencyContactTableViewController: UITableViewController {

    // MARK: Internal

    @IBOutlet var emergencyContactName: UITextField!
    @IBOutlet var emergencyContactNumber: UITextField!
    @IBOutlet var emergencyContactRelationship: UITextField!

    @IBAction func completeButtonTapped(_ sender: UIButton) {
        guard validateFields() else { return }

        performSegue(withIdentifier: "segueShowInitialTabBarViewController", sender: nil)
    }

    // MARK: Private

    private func validateFields() -> Bool {
        guard let name = emergencyContactName.text, !name.isEmpty else {
            showAlert(message: "Emergency Contact Name is required")
            return false
        }

        guard let number = emergencyContactNumber.text, !number.isEmpty, !number.isPhoneNumber() else {
            showAlert(message: "Emergency Contact Number is required")
            return false
        }

        guard let relationship = emergencyContactRelationship.text, !relationship.isEmpty else {
            showAlert(message: "Emergency Contact Relationship is required")
            return false
        }

        if !number.isPhoneNumber() {
            showAlert(message: "Emergency Contact Number is invalid")
            return false
        }

        return true
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
