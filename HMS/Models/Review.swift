import Foundation

struct Review: Identifiable, Codable {
    let id: String
    let patientId: String
    let patientName: String
    let doctorId: String
    let rating: Double
    let comment: String
    let date: Date
    
    init(
        id: String = UUID().uuidString,
        patientId: String,
        patientName: String,
        doctorId: String,
        rating: Double,
        comment: String,
        date: Date = Date()
    ) {
        self.id = id
        self.patientId = patientId
        self.patientName = patientName
        self.doctorId = doctorId
        self.rating = rating
        self.comment = comment
        self.date = date
    }
} 