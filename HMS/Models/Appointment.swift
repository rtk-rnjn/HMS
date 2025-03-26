//
//  Appointment.swift
//  HMS
//
//  Created by RITIK RANJAN on 26/03/25.
//

import Foundation

enum AppointmentStatus: String {
    case confirmed = "Confirmed"
}

struct Appointment {
    var id: String = UUID().uuidString

    var patientId: String
    var doctorId: String

    var reason: String
    var doctorNotes: String? = nil

    var doctorName: String?
    var doctorSpecializations: String?

    var date: Date
    var status: AppointmentStatus = .confirmed
}

