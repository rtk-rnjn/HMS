//

//

//

import Foundation

enum AppointmentStatus: String, Codable {
    case confirmed = "Confirmed"
    case completed = "Completed"
    case cancelled = "Cancelled"
    case onGoing = "On going"
}

struct Appointment: Codable, Identifiable, Hashable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case patientId = "patient_id"
        case doctorId = "doctor_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case _status = "status"
        case prescription
        case notes
        case reference
        case createdAt = "created_at"
        case cancelled
    }

    var id: String = UUID().uuidString

    var patientId: String
    var patient: Patient?

    var doctorId: String
    var doctor: Staff?

    var startDate: Date
    var endDate: Date
    var _status: AppointmentStatus
    var status: AppointmentStatus {
        let now = Date()

        if startDate < now && now < endDate {
            return .onGoing
        } else if endDate < now {
            return .completed
        } else {
            return .confirmed
        }
    }

    var prescription: String?
    var notes: String?

    var reference: String?
    var createdAt: Date = .init()

    var cancelled: Bool = false
}
