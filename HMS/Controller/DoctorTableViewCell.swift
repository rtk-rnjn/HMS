//
//  DoctorTableViewCell.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import UIKit

class DoctorTableViewCell: UITableViewCell {
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var specializationLabel: UILabel!

    func updateElements(with doctor: Staff) {
        fullNameLabel.text = doctor.fullName
        specializationLabel.text = doctor.specializations.joined(separator: ", ")
    }
}
