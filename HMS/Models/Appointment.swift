//
//  Appointment.swift
//  HMS
//
//  Created by RITIK RANJAN on 26/03/25.
//

import Foundation

enum AppointmentStatus: String, Codable {
    case confirmed = "Confirmed"
    case completed = "Completed"
}

struct Appointment: Codable, Identifiable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case patientId = "patient_id"
        case doctorId = "doctor_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case status
        case prescription
        case notes
        case reference
        case createdAt = "created_at"
    }

    var id: String = UUID().uuidString

    var patientId: String
    var patient: Patient?

    var doctorId: String
    var doctor: Staff?

    var startDate: Date
    var endDate: Date
    var status: AppointmentStatus = .confirmed

    var prescription: String?
    var notes: String?

    var reference: String?
    var createdAt: Date = .init()

}
