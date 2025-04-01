//
//  Announcement.swift
//  HMS
//
//  Created by RITIK RANJAN on 01/04/25.
//

import Foundation

struct Announcement: Codable, Equatable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
        case broadcastTo = "broadcast_to"
        case category
    }

    var id: UUID = .init()

    var title: String
    var body: String
    var createdAt: Date = .init()
    var broadcastTo: [String] = []
    var category: AnnouncementCategory = .general
}

enum AnnouncementCategory: String, Codable, CaseIterable {
    case general = "General"
    case emergency = "Emergency"
    case appointment = "Appointment"
    case holiday = "Holiday"
}
