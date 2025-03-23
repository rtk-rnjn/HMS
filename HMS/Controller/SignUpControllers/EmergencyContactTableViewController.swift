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

    var patient: Patient?

    @IBAction func completeButtonTapped(_ sender: UIButton) {
        guard validateFields() else { return }

        patient?.emergencyContactName = emergencyContactName.text!
        patient?.emergencyContactNumber = emergencyContactNumber.text!
        patient?.emergencyContactRelationship = emergencyContactRelationship.text!

        Task {
            guard let patient else { return }
            let created = await DataController.shared.createPatient(patient: patient)
            DispatchQueue.main.async {
                if created {
                    self.performSegue(withIdentifier: "segueShowInitialTabBarViewController", sender: nil)
                } else {
                    self.showAlert(message: "Failed to create patient")
                }
            }
        }
    }

    // MARK: Private

    private func validateFields() -> Bool {
        guard let name = emergencyContactName.text, !name.isEmpty else {
            showAlert(message: "Emergency Contact Name is required")
            return false
        }

        guard let number = emergencyContactNumber.text, !number.isEmpty else {
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
