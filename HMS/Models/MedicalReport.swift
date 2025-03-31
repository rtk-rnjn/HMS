import Foundation

struct MedicalReport: Identifiable, Codable {
    let id: String
    let reportType: String
    let description: String
    let reportDate: Date
    let attachmentURL: String?
    let createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        reportType: String,
        description: String,
        reportDate: Date,
        attachmentURL: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.reportType = reportType
        self.description = description
        self.reportDate = reportDate
        self.attachmentURL = attachmentURL
        self.createdAt = createdAt
    }
} 