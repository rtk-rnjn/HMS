//
//  AppointmentsTableViewCell.swift
//  HMS
//
//  Created by RITIK RANJAN on 26/03/25.
//

import UIKit

class AppointmentsTableViewCell: UITableViewCell {

    @IBOutlet var staffName: UILabel!
    @IBOutlet var staffDepartment: UILabel!
    @IBOutlet var date: UIDatePicker!

    func updateElements(with appointment: Appointment) {
        staffName.text = appointment.doctorName
        staffDepartment.text = appointment.doctorSpecializations
        date.date = appointment.date
    }
}
