//

//

//

import SwiftUI

struct AppointmentView: View {

    // MARK: Internal

    weak var delegate: AppointmentHostingController?
    var appointments: [Appointment] = []

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            if appointments.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.largeTitle)
                        .foregroundColor(Color("iconBlue"))
                    Text("No Appointments Found")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    Text("Your scheduled appointments will appear here")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(sortedAppointments) { appointment in
                            AppointmentDetailCard(appointment: appointment)
                                .onTapGesture {
                                    delegate?.showAppointmentDetails(appointment)
                                }
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                }
            }
        }
        .onAppear {

            delegate?.refreshAppointments()
        }
    }

    // MARK: Private

    private var sortedAppointments: [Appointment] {
        appointments.sorted {

            if $0.startDate >= Date() && $1.startDate < Date() {
                return true
            } else if $0.startDate < Date() && $1.startDate >= Date() {
                return false
            } else {
                return $0.startDate < $1.startDate
            }
        }
    }
}

struct AppointmentRow: View {
    var appointment: Appointment
    var isPast: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(appointment.doctor?.fullName ?? "Unknown Doctor")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(appointment.startDate, style: .time)
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
        .opacity(isPast ? 0.5 : 1.0)
    }
}
