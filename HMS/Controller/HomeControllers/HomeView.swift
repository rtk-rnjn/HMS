import SwiftUI

struct AppointmentCard: View {

    // MARK: Internal

    let appointment: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                // Doctor info
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.doctor?.fullName ?? "Unknown Doctor")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)

                    Text(appointment.doctor?.department ?? "Department")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Date and time
                VStack(alignment: .trailing, spacing: 4) {
                    Text(formattedDate())
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)

                    Text("at \(formattedTime())")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                }
            }

            // Status pill - bottom right
            HStack {
                Spacer()
                Text(appointment.status.rawValue)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                    )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        .padding(.horizontal, 16)
        .padding(.vertical, 2)
    }

    // MARK: Private

    private func formattedDate() -> String {
        let day = Calendar.current.component(.day, from: appointment.startDate)
        let month = Calendar.current.shortMonthSymbols[Calendar.current.component(.month, from: appointment.startDate) - 1]
        let year = Calendar.current.component(.year, from: appointment.startDate)
        return "\(day) \(month) \(year)"
    }

    private func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: appointment.startDate).uppercased()
    }
}

struct StatusTag: View {

    // MARK: Internal

    let status: AppointmentStatus

    var body: some View {
        // Text label for statuses
        Text(status.rawValue)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(statusColor.opacity(0.12))
            .clipShape(Capsule())
    }

    // MARK: Private

    private var statusColor: Color {
        switch status {
        case .confirmed: return .green
        case .completed: return .blue
        }
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
                    .foregroundColor(Color("iconBlue"))
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
                    .foregroundColor(Color("iconBlue"))
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
