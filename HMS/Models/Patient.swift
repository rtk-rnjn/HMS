//
//  Patient.swift
//  HMS
//
//  Created by RITIK RANJAN on 19/03/25.
//

import Foundation

enum Role: String, Codable {
    case patient
    case doctor
}

enum BloodGroup: String, Codable {
    case aPositive = "A+"
    case aNegative = "A-"
    case bPositive = "B+"
    case bNegative = "B-"
    case abPositive = "AB+"
    case abNegative = "AB-"
    case oPositive = "O+"
    case oNegative = "O-"
}

struct Patient: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case emailAddress = "email_address"
        case password = "password"
        case dateOfBirth = "date_of_birth"
        case bloodGroup = "blood_group"
        case height
        case weight
        case allergies
        case medications
        case emergencyContactName = "emergency_contact_name"
        case emergencyContactNumber = "emergency_contact_number"
        case emergencyContactRelationship = "emergency_contact_relationship"
        case role
        case active
    }

    var id: String = UUID().uuidString

    var firstName: String
    var lastName: String?

    var emailAddress: String
    var password: String
    var dateOfBirth: Date
    var bloodGroup: BloodGroup
    var height: Int
    var weight: Int
    var allergies: [String]
    var medications: [String]

    var emergencyContactName: String
    var emergencyContactNumber: String
    var emergencyContactRelationship: String

    var role: Role = .patient
    var active: Bool = true

    var fullName: String? {
        guard let lastName else {
            return firstName
        }
        return "\(firstName) \(lastName)"
    }
}
