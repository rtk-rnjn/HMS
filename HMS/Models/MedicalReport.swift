//
//  MedicalReport.swift
//  HMS
//
//  Created by RITIK RANJAN on 01/04/25.
//

import Foundation
import UIKit

struct MedicalReport: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case description
        case date
        case type
        case imageData = "image_data"
    }

    var id: String = UUID().uuidString
    var description: String
    var date: Date
    var type: String
    var imageData: Data?

    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}
