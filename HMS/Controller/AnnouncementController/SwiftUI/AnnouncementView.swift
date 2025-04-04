//

//

//

import SwiftUI

struct AnnouncementView: View {

    // MARK: Internal

    var announcements: [Announcement] = []

    var body: some View {
        List {
            ForEach(groupedAnnouncements.keys.sorted(by: >), id: \.self) { section in
                Section(header: Text(section)) {
                    ForEach(groupedAnnouncements[section] ?? [], id: \.title) { announcement in
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
                                Text(announcement.createdAt, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(4)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    private var groupedAnnouncements: [String: [Announcement]] {
        let calendar = Calendar.current
        let now = Date()

        return Dictionary(grouping: announcements) { announcement in
            if calendar.isDateInToday(announcement.createdAt) {
                return "Today"
            } else if calendar.isDateInYesterday(announcement.createdAt) {
                return "Yesterday"
            } else if calendar.isDate(announcement.createdAt, equalTo: now, toGranularity: .weekOfYear) {
                return "This Week"
            } else {
                return "Earlier"
            }
        }
    }

    private func categoryIcon(for category: AnnouncementCategory) -> Image {
        switch category {
        case .general: return Image(systemName: "megaphone.fill")
        case .emergency: return Image(systemName: "exclamationmark.triangle.fill")
        case .appointment: return Image(systemName: "calendar.badge.clock")
        }
    }

    private func categoryColor(for category: AnnouncementCategory) -> Color {
        switch category {
        case .general: return .primaryBlue
        case .emergency: return .airleblue
        case .appointment: return .secondaryBlue
        }
    }
}

// MARK: - Previews
struct AnnouncementView_Previews: PreviewProvider {
    static var sampleAnnouncements: [Announcement] = [
        // Today
        Announcement(
            title: "Hospital Timings Update",
            body: "OPD hours extended till 8 PM on weekdays starting next week",
            createdAt: Date(),
            category: .general
        ),
        Announcement(
            title: "Emergency Department Alert",
            body: "Additional staff deployed in emergency ward due to increased cases",
            createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
            category: .emergency
        ),
        // Yesterday
        Announcement(
            title: "Your Appointment Rescheduled",
            body: "Dr. Sharma's appointment for tomorrow has been moved to 3 PM",
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            category: .appointment
        ),
        // Earlier
        Announcement(
            title: "New COVID Protocol",
            body: "Updated safety protocols for all hospital visitors",
            createdAt: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
            category: .general
        )
    ]

    static var previews: some View {
        NavigationView {
            AnnouncementView(announcements: sampleAnnouncements)
                .preferredColorScheme(.light)
        }

        NavigationView {
            AnnouncementView(announcements: sampleAnnouncements)
                .preferredColorScheme(.dark)
        }
    }

}
