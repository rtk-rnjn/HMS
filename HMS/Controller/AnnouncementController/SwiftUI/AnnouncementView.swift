//
//  AnnouncementView.swift
//  HMS
//
//  Created by RITIK RANJAN on 01/04/25.
//

import SwiftUI

struct AnnouncementView: View {

    // MARK: Internal

    var announcements: [Announcement] = []

    var body: some View {
        NavigationView {
            List(announcements, id: \.title) { announcement in
                HStack(spacing: 12) {
                    categoryIcon(for: announcement.category)
                        .foregroundColor(categoryColor(for: announcement.category))
                        .font(.title2)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(announcement.title)
                            .font(.headline)
                        Text(announcement.body)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(announcement.createdAt, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(4)
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    private func categoryIcon(for category: AnnouncementCategory) -> Image {
        switch category {
        case .general: return Image(systemName: "megaphone.fill")
        case .emergency: return Image(systemName: "exclamationmark.triangle.fill")
        case .appointment: return Image(systemName: "calendar.badge.clock")
        case .holiday: return Image(systemName: "gift.fill")
        }
    }

    private func categoryColor(for category: AnnouncementCategory) -> Color {
        switch category {
        case .general: return .blue
        case .emergency: return .red
        case .appointment: return .green
        case .holiday: return .orange
        }
    }
}
