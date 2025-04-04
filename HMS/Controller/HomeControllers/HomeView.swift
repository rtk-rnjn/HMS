import SwiftUI

struct AppointmentCard: View {

    // MARK: Internal

    let appointment: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {

                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.doctor?.fullName ?? "Unknown Doctor")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(appointment.doctor?.department ?? "Department")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(formattedDate())
                        .font(.subheadline)
                        .foregroundColor(.primary)

                    Text("at \(formattedTime())")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            HStack {
                Spacer()
                Text(appointment.status.rawValue)
                    .font(.footnote)
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

        Text(status.rawValue)
            .font(.caption2)
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(statusColor.opacity(0.12))
            .clipShape(Capsule())
    }

    // MARK: Private

    private var statusColor: Color {
        switch status {
        case .confirmed: return Color("successBlue")
        case .completed: return Color("secondaryBlue")
        case .cancelled: return Color("errorBlue")
        case .onGoing:   return Color("primaryBlue")
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
                    .font(.title2)
                    .foregroundColor(Color("iconBlue"))
                Spacer()
            }

            Text(title)
                .font(.headline)

            Text(date)
                .font(.callout)
                .foregroundColor(.gray)

            HStack {
                Circle()
                    .fill(Color("errorBlue"))
                    .frame(width: 8, height: 8)
                Text(status)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}
