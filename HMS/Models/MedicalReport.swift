//

//

//

import Foundation
import UIKit

struct MedicalReport: Codable, Identifiable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case description
        case date
        case type
        case imageData = "image_data"
        case status
    }

    var id: String = UUID().uuidString
    var description: String
    var date: Date
    var type: String
    var imageData: Data?
    var status: String?

    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
    
    // Implement Equatable
    static func == (lhs: MedicalReport, rhs: MedicalReport) -> Bool {
        return lhs.id == rhs.id &&
               lhs.description == rhs.description &&
               lhs.date == rhs.date &&
               lhs.type == rhs.type &&
               lhs.status == rhs.status
    }
}
