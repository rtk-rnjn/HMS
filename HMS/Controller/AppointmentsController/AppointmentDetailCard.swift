import SwiftUI

struct AppointmentDetailCard: View {

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
