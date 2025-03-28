//
//  AppointmentHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

let calendar = Calendar.current
let currentDate: Date = Date()

let sampleAppointments = [
    Appointment(patientId: "12345", doctorId: "D001", reason: "General Checkup", doctorNotes: nil, doctorName: "Dr. Smith", doctorSpecializations: "Cardiology", date: calendar.date(byAdding: .day, value: -10, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D002", reason: "Dental Checkup", doctorNotes: "Needs follow-up", doctorName: "Dr. Adams", doctorSpecializations: "Dentistry", date: calendar.date(byAdding: .day, value: -7, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D003", reason: "Eye Examination", doctorNotes: nil, doctorName: "Dr. Johnson", doctorSpecializations: "Ophthalmology", date: calendar.date(byAdding: .day, value: -5, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D004", reason: "Orthopedic Consultation", doctorNotes: "Possible fracture", doctorName: "Dr. Lee", doctorSpecializations: "Orthopedics", date: calendar.date(byAdding: .day, value: -3, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D005", reason: "Routine Blood Test", doctorNotes: "Check cholesterol levels", doctorName: "Dr. Patel", doctorSpecializations: "Pathology", date: calendar.date(byAdding: .day, value: -1, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D006", reason: "General Checkup", doctorNotes: nil, doctorName: "Dr. Smith", doctorSpecializations: "Cardiology", date: currentDate),
    Appointment(patientId: "12345", doctorId: "D007", reason: "Physical Therapy", doctorNotes: "Leg pain", doctorName: "Dr. Garcia", doctorSpecializations: "Physiotherapy", date: calendar.date(byAdding: .day, value: 1, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D008", reason: "ENT Consultation", doctorNotes: "Chronic sinusitis", doctorName: "Dr. Brown", doctorSpecializations: "ENT", date: calendar.date(byAdding: .day, value: 2, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D009", reason: "Skin Allergy Test", doctorNotes: "Possible eczema", doctorName: "Dr. Wilson", doctorSpecializations: "Dermatology", date: calendar.date(byAdding: .day, value: 3, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D010", reason: "Diabetes Checkup", doctorNotes: "Monitor sugar levels", doctorName: "Dr. Martinez", doctorSpecializations: "Endocrinology", date: calendar.date(byAdding: .day, value: 4, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D011", reason: "Cardiac Screening", doctorNotes: "Possible hypertension", doctorName: "Dr. Scott", doctorSpecializations: "Cardiology", date: calendar.date(byAdding: .day, value: 5, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D012", reason: "Psychiatric Evaluation", doctorNotes: "Anxiety management", doctorName: "Dr. Hall", doctorSpecializations: "Psychiatry", date: calendar.date(byAdding: .day, value: 6, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D013", reason: "Neurological Examination", doctorNotes: "Headaches", doctorName: "Dr. Allen", doctorSpecializations: "Neurology", date: calendar.date(byAdding: .day, value: 7, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D014", reason: "Pediatric Checkup", doctorNotes: "Child fever", doctorName: "Dr. Thomas", doctorSpecializations: "Pediatrics", date: calendar.date(byAdding: .day, value: 8, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D015", reason: "Annual Physical Exam", doctorNotes: nil, doctorName: "Dr. White", doctorSpecializations: "General Medicine", date: calendar.date(byAdding: .day, value: 9, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D016", reason: "Vaccination", doctorNotes: "Flu shot", doctorName: "Dr. Harris", doctorSpecializations: "Preventive Medicine", date: calendar.date(byAdding: .day, value: 10, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D017", reason: "Mental Health Counseling", doctorNotes: "Stress management", doctorName: "Dr. Nelson", doctorSpecializations: "Psychology", date: calendar.date(byAdding: .day, value: 11, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D018", reason: "Nutrition Consultation", doctorNotes: "Diet improvement", doctorName: "Dr. Carter", doctorSpecializations: "Nutrition", date: calendar.date(byAdding: .day, value: 12, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D019", reason: "Gastroenterology Checkup", doctorNotes: "Acid reflux", doctorName: "Dr. Wright", doctorSpecializations: "Gastroenterology", date: calendar.date(byAdding: .day, value: 13, to: currentDate)!),
    Appointment(patientId: "12345", doctorId: "D020", reason: "Sleep Study", doctorNotes: "Insomnia", doctorName: "Dr. King", doctorSpecializations: "Sleep Medicine", date: calendar.date(byAdding: .day, value: 14, to: currentDate)!)
]

class AppointmentHostingController: UIHostingController<AppointmentView>, UISearchBarDelegate, UISearchResultsUpdating {
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AppointmentView())
    }
    
    // MARK: Internal
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.appointments = sampleAppointments
        self.rootView.delegate = self

        prepareSearchController()
    }

    var searchController: UISearchController = .init()

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Appointments"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func updateSearchResults(for searchController: UISearchController) {
    }
}

