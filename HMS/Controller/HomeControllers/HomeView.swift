import SwiftUI

struct AppointmentCard: View {
    let date: String
    let time: String
    let doctorName: String
    let specialty: String
    let hospital: String
    let status: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(date)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                    Text(time)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }

                if let status {
                    Spacer()
                    Text(status)
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                }
            }

            Text(doctorName)
                .font(.system(size: 18, weight: .semibold))

            Text(specialty)
                .font(.system(size: 16))
                .foregroundColor(.gray)

            Text(hospital)
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(color.opacity(0.1))
            .cornerRadius(16)
        }
    }
}

struct LabReportCard: View {
    let title: String
    let date: String
    let status: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "doc.text")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                Spacer()
            }

            Text(title)
                .font(.system(size: 18, weight: .semibold))

            Text(date)
                .font(.system(size: 16))
                .foregroundColor(.gray)

            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text(status)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct HomeView: View {

    // MARK: Internal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search hospitals, doctors, services...", text: $searchText)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // Upcoming Appointments
                VStack(alignment: .leading, spacing: 16) {
                    Text("Upcoming Appointments")
                        .font(.system(size: 24, weight: .bold))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            AppointmentCard(
                                date: "Today",
                                time: "14:30",
                                doctorName: "Dr. Sarah Wilson",
                                specialty: "Cardiology",
                                hospital: "Central Hospital",
                                status: "Confirmed"
                            )

                            AppointmentCard(
                                date: "Tomorrow",
                                time: "10:15",
                                doctorName: "Dr. Michael Brown",
                                specialty: "Neurology",
                                hospital: "City Medical Center",
                                status: nil
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)

                // Quick Actions Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    QuickActionButton(
                        icon: "building.2",
                        title: "Book Appointment",
                        color: .blue
                    ) {
                        // Handle book appointment
                    }

                    QuickActionButton(
                        icon: "cross.case",
                        title: "Emergency Services",
                        color: .red
                    ) {
                        // Handle emergency services
                    }

                    QuickActionButton(
                        icon: "folder.fill",
                        title: "Medical Records",
                        color: .green
                    ) {
                        // Handle medical records
                    }

                    QuickActionButton(
                        icon: "video",
                        title: "Video Consultation",
                        color: .purple
                    ) {
                        // Handle video consultation
                    }
                }
                .padding(.horizontal)

                // Recent Lab Reports
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Recent Lab Reports")
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                        Button("See All") {
                            // Handle see all
                        }
                        .foregroundColor(.blue)
                    }

                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        LabReportCard(
                            title: "Blood Test",
                            date: "Oct 15, 2023",
                            status: "Completed"
                        )

                        LabReportCard(
                            title: "X-Ray Report",
                            date: "Oct 10, 2023",
                            status: "Completed"
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: Private

    @State private var searchText = ""

}

#Preview {
    AppointmentCard(date: "23 March 2025", time: "9:00 AM", doctorName: "Doctor", specialty: "All in one", hospital: "Apollo", status: "PENDING")
}
