//
//  MedicalInformationTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class MedicalInformationTableViewController: UITableViewController {

    // MARK: Internal

    @IBOutlet var bloodGroupButton: UIButton!
    @IBOutlet var heightButton: UIButton!
    @IBOutlet var weightButton: UIButton!
    @IBOutlet var allergiesTextField: UITextField!
    @IBOutlet var medicationTextField: UITextField!
    @IBOutlet var nextButton: UIButton!

    var patient: Patient?

    var validInput: Bool {
        return bloodGroupButton.titleLabel?.text != "Not Known" && heightButton.titleLabel?.text != "None" && weightButton.titleLabel?.text != "None"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowPickerViewController", let pickerViewController = segue.destination as? PickerViewController, let presentationController = segue.destination.presentationController as? UISheetPresentationController {

            guard let (sender, options) = sender as? (UIButton, [String: String]) else { return }
            pickerViewController.options = options
            pickerViewController.completionHandler = { _, value in
                sender.setTitle(value, for: .normal)
                self.nextButton.isEnabled = self.validInput
            }

            presentationController.detents = [.medium()]
        }
    }

    @IBAction func bloodGroupButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowPickerViewController", sender: (sender, bloodGroup))
    }

    @IBAction func heightButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowPickerViewController", sender: (sender, heights))
    }

    @IBAction func weightButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowPickerViewController", sender: (sender, weights))
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard validateFields() else { return }

        patient?.bloodGroup = BloodGroup(rawValue: bloodGroupButton.titleLabel?.text ?? "")!
        let height = Int((heightButton.titleLabel?.text ?? "").components(separatedBy: " ")[0])
        let weight = Int((weightButton.titleLabel?.text ?? "").components(separatedBy: " ")[0])

        patient?.height = height!
        patient?.weight = weight!

        if allergiesTextField.text?.isEmpty ?? false {
            let allergies: [String] = allergiesTextField.text?.components(separatedBy: ",") ?? []
            patient?.allergies = allergies
        }

        if medicationTextField.text?.isEmpty ?? false {
            let medications: [String] = medicationTextField.text?.components(separatedBy: ",") ?? []
            patient?.medications = medications
        }
    }

    // MARK: Private

    private let bloodGroup: [String: String] = {
        var groups = BloodGroup.allCases.reduce(into: [:]) { $0[$1.rawValue] = $1.rawValue }
        groups[""] = ""
        return groups
    }()

    private let heights: [String: String] = {
        var heights = ["": ""]
        for i in 120...220 {
            heights[String(i)] = "\(i) cm"
        }
        return heights
    }()

    private let weights: [String: String] = {
        var weights: [String: String] = [:]
        for i in 10...200 {
            weights[String(i)] = "\(i) kg"
        }
        return weights
    }()

    private func validateFields() -> Bool {
        guard let bloodGroup = bloodGroupButton.titleLabel?.text, !bloodGroup.isEmpty, bloodGroup != "Not Known" else {
            showAlert(message: "Blood group is required")
            return false
        }

        guard let height = heightButton.titleLabel?.text, !height.isEmpty, height != "None" else {
            showAlert(message: "Height is required")
            return false
        }

        guard let weight = weightButton.titleLabel?.text, !weight.isEmpty, weight != "None" else {
            showAlert(message: "Weight is required")
            return false
        }

        return true
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true)
    }

}
