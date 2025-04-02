//
//  Staff.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import Foundation

struct WorkingHours: Codable, Equatable, Hashable {
    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
    }

    var startTime: Date
    var endTime: Date
}

struct Staff: Codable, Equatable, Hashable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case emailAddress = "email_address"
        case password = "password"
        case contactNumber = "contact_number"
        case dateOfBirth = "date_of_birth"
        case specialization = "specialization"
        case department = "department"
        case onLeave = "on_leave"
        case consultationFee = "consultation_fee"
        case joiningDate = "joining_date"
        case licenseId = "license_id"
        case yearOfExperience = "year_of_experience"
        case role = "role"
        case hospitalId = "hospital_id"
        case workingHours = "working_hours"
    }

    var id: String = UUID().uuidString
    var firstName: String
    var lastName: String?

    var gender: Gender = .other

    var emailAddress: String
    var dateOfBirth: Date
    var password: String
    var contactNumber: String
    var specialization: String
    var department: String
    var onLeave: Bool = false
    var consultationFee: Int = 0

    var joiningDate: Date = .init()
    var licenseId: String
    var yearOfExperience: Int = 0
    var role: Role = .doctor

    var hospitalId: String = ""

    var workingHours: WorkingHours?

    var fullName: String {
        let lastName = lastName ?? ""
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

    var appointments: [Appointment] = []

}
