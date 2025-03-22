//
//  DoctorProfileTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class DoctorProfileTableViewController: UITableViewController {
    var doctor: Staff?

    @IBOutlet var staffNameLabel: UILabel!
    @IBOutlet var specializationsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let doctor {
            staffNameLabel.text = doctor.fullName

            let specializationsText = doctor.specializations.joined(separator: ", ")
            if !specializationsText.isEmpty {
                specializationsLabel.text = specializationsText
            } else {
                specializationsLabel.isHidden = true
            }

        }
    }

}
