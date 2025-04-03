//
//  RazorpayPaymentlinkResponse.swift
//  HMS
//
//  Created by RITIK RANJAN on 03/04/25.
//


import Foundation

struct RazorpayPaymentlinkResponse: Codable, Sendable, Identifiable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case amountPaid = "amount_paid"
        case notes
        case payments
        case _createdAt = "created_at"
    }

    var id: String
    var amountPaid: Int
    var notes: RazorpayNotes
    var payments: [RazorpayPayment]
    var _createdAt: TimeInterval

    var createdAt: Date {
        Date(timeIntervalSince1970: _createdAt)
    }
}

struct RazorpayNotes: Codable, Sendable, Identifiable, Hashable {
    enum CodingKeys: String, CodingKey {
        case doctorId = "doctor_id"
        case endDate = "end_date"
        case patientId = "patient_id"
        case startDate = "start_date"
    }

    var id: String = UUID().uuidString

    var doctorId: String
    var patientId: String

    var endDate: Date
    var startDate: Date
}

struct RazorpayPayment: Codable, Sendable, Identifiable, Hashable {
    enum CodingKeys: String, CodingKey {
        case amount
        case createdAt = "created_at"
        case method
        case status
    }

    var id: String = UUID().uuidString

    var amount: Int
    var createdAt: TimeInterval
    var method: String = "card"
    var status: String = "captured"
}

