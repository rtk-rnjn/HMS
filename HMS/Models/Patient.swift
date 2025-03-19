//
//  Patient.swift
//  HMS
//
//  Created by RITIK RANJAN on 19/03/25.
//

import Foundation

enum Role: String, Codable {
    case patient
}

struct Patient: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case emailAddress = "email_address"
        case password = "password"
        case role = "role"
    }

    let id: String = UUID().uuidString
    let emailAddress: String
    let password: String
    let role: Role = .patient
}
