//

//

//

import Foundation

struct Review: Codable, Hashable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case patientId = "patient_id"
        case doctorId = "doctor_id"
        case stars
        case review
        case createdAt = "created_at"
    }

    var id: String = UUID().uuidString
    var review: String

    var patientId: String
    var doctorId: String

    var stars: Int = 0
    var createdAt: Date = .init()
}
