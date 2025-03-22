//
//  MedicalInformationTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class MedicalInformationTableViewController: UITableViewController {

    // MARK: Internal

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowPickerViewController", let pickerViewController = segue.destination as? PickerViewController, let presentationController = segue.destination.presentationController as? UISheetPresentationController {

            guard let (sender, options) = sender as? (UIButton, [String: String]) else { return }
            pickerViewController.options = options
            pickerViewController.completionHandler = { _, value in
                sender.setTitle(value, for: .normal)
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
        performSegue(withIdentifier: "segueShowEmergencyContactTableViewController", sender: nil)
    }

    // MARK: Private

    private let bloodGroup = ["": "", "A+": "A Positive", "A-": "A Negative", "B+": "B Positive", "B-": "B Negative", "AB+": "AB Positive", "AB-": "AB Negative", "O+": "O Positive", "O-": "O Negative"]
    private let heights: [String: String] = {
        var heights = ["": ""]
        for i in 120...220 {
            heights[String(i)] = "\(i) cm"
        }
        return heights
    }()

    private let weights: [String: String] = {
        var weights = ["": ""]
        for i in 30...200 {
            weights[String(i)] = "\(i) kg"
        }
        return weights
    }()

}
