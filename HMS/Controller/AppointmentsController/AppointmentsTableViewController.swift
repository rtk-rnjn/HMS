//
//  AppointmentsTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 26/03/25.
//

import UIKit
import Foundation

func generateDate(daysOffset: Int) -> Date {
    return Calendar.current.date(byAdding: .day, value: daysOffset, to: Date())!
}

let sampleAppointments: [Int: [Appointment]] = [
    0: [
        Appointment(patientId: "PAT001", doctorId: "DOC001", reason: "Regular Checkup", doctorNotes: "Patient in good health", doctorName: "Dr. John Doe", doctorSpecializations: "Cardiology", date: generateDate(daysOffset: 0)),
        Appointment(patientId: "PAT002", doctorId: "DOC002", reason: "Flu Symptoms", doctorNotes: "Prescribed antiviral medication", doctorName: "Dr. Alice Smith", doctorSpecializations: "General Medicine", date: generateDate(daysOffset: 0))
    ],
    1: [
        Appointment(patientId: "PAT003", doctorId: "DOC003", reason: "Back Pain", doctorNotes: "Recommended physiotherapy", doctorName: "Dr. Robert Johnson", doctorSpecializations: "Orthopedics", date: generateDate(daysOffset: 1)),
        Appointment(patientId: "PAT004", doctorId: "DOC004", reason: "Migraine", doctorNotes: "Prescribed painkillers", doctorName: "Dr. Emily Davis", doctorSpecializations: "Neurology", date: generateDate(daysOffset: 1)),
        Appointment(patientId: "PAT005", doctorId: "DOC005", reason: "Skin Rash", doctorNotes: "Recommended ointment", doctorName: "Dr. Michael Brown", doctorSpecializations: "Dermatology", date: generateDate(daysOffset: 1))
    ],
    2: [
        Appointment(patientId: "PAT006", doctorId: "DOC006", reason: "Diabetes Consultation", doctorNotes: "Blood sugar levels monitored", doctorName: "Dr. Sophia Wilson", doctorSpecializations: "Endocrinology", date: generateDate(daysOffset: 2))
    ],
    3: [
        Appointment(patientId: "PAT007", doctorId: "DOC007", reason: "Vision Test", doctorNotes: "Mild myopia detected", doctorName: "Dr. David Martinez", doctorSpecializations: "Ophthalmology", date: generateDate(daysOffset: 3)),
        Appointment(patientId: "PAT008", doctorId: "DOC008", reason: "Dental Checkup", doctorNotes: "Cavity found, scheduled filling", doctorName: "Dr. Olivia Anderson", doctorSpecializations: "Dentistry", date: generateDate(daysOffset: 3))
    ],
    4: [
        Appointment(patientId: "PAT009", doctorId: "DOC009", reason: "Allergy Symptoms", doctorNotes: "Advised antihistamines", doctorName: "Dr. James Lee", doctorSpecializations: "Immunology", date: generateDate(daysOffset: 4)),
        Appointment(patientId: "PAT010", doctorId: "DOC010", reason: "Heart Checkup", doctorNotes: "ECG performed, normal results", doctorName: "Dr. Emma Thomas", doctorSpecializations: "Cardiology", date: generateDate(daysOffset: 4))
    ],
    5: [
        Appointment(patientId: "PAT011", doctorId: "DOC011", reason: "Asthma Follow-up", doctorNotes: "Lung function test scheduled", doctorName: "Dr. Benjamin White", doctorSpecializations: "Pulmonology", date: generateDate(daysOffset: 5)),
        Appointment(patientId: "PAT012", doctorId: "DOC012", reason: "Thyroid Check", doctorNotes: "TSH levels checked", doctorName: "Dr. Charlotte Harris", doctorSpecializations: "Endocrinology", date: generateDate(daysOffset: 5)),
        Appointment(patientId: "PAT013", doctorId: "DOC013", reason: "Knee Pain", doctorNotes: "MRI scheduled", doctorName: "Dr. Daniel Clark", doctorSpecializations: "Orthopedics", date: generateDate(daysOffset: 5))
    ],
    6: [
        Appointment(patientId: "PAT014", doctorId: "DOC014", reason: "Hypertension Management", doctorNotes: "Adjusted medication dosage", doctorName: "Dr. Ava Robinson", doctorSpecializations: "Internal Medicine", date: generateDate(daysOffset: 6)),
        Appointment(patientId: "PAT015", doctorId: "DOC015", reason: "Pregnancy Consultation", doctorNotes: "Ultrasound scheduled", doctorName: "Dr. William Walker", doctorSpecializations: "Obstetrics", date: generateDate(daysOffset: 6))
    ]
]

let dates = (0...6).map { $0 }

class AppointmentsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    // MARK: Internal

    var searchController: UISearchController = .init()
    var appointments: [Int: [Appointment]] = sampleAppointments

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSearchController()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments[dates[section]]?.count ?? 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = generateDate(daysOffset: dates[section])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter.string(from: date)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentsTableViewCell", for: indexPath) as? AppointmentsTableViewCell

        guard let cell else { fatalError() }

        let appointment = appointments[dates[indexPath.section]]![indexPath.row]
        cell.updateElements(with: appointment)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueShowAppointmentDetailViewController", sender: self)
    }

    func updateSearchResults(for searchController: UISearchController) {}

    // MARK: Private

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Appointments"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}
