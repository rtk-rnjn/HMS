import SwiftUI

protocol AppointmentDetailDelegate: AnyObject {
    func refreshAppointments()
}

struct AppointmentDetailView: View {
    let appointment: Appointment
    weak var delegate: AppointmentDetailDelegate?
    @Environment(\.dismiss) private var dismiss
    @State private var showingCancelAlert = false
    @State private var showingErrorAlert = false

    // Custom colors
    let customBlue: Color = .init(red: 0.27, green: 0.45, blue: 1.0)

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Doctor Profile Section
                VStack(spacing: 12) {
                    // Profile Card
                    VStack(spacing: 8) {
                        Circle()
                            .fill(Color(UIColor.systemGray4))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color("iconBlue"))
                            )
                            .padding(.bottom, 4)

                        Text(appointment.doctor?.fullName ?? "Doctor Name")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(appointment.doctor?.specialization ?? "Specialist")
                            .font(.body)
                            .foregroundColor(customBlue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)

                    // Stats Section
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 24))
                                .foregroundColor(customBlue)
                            Text("0")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Patients")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        Spacer()
                        Divider()
                            .frame(height: 40)
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 24))
                                .foregroundColor(customBlue)
                            Text("\(appointment.doctor?.yearOfExperience ?? 4) yrs")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Experience")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        Spacer()
                        Divider()
                            .frame(height: 40)
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 24))
                                .foregroundColor(customBlue)
                            Text("4.8")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Rating")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                }
                .padding(.horizontal)

                // Appointment Details Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Appointment Details")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    VStack(spacing: 16) {
                        AppointmentDetailRow(
                            icon: "calendar",
                            title: "Date",
                            value: appointment.startDate.formatted(date: .long, time: .omitted)
                        )

                        AppointmentDetailRow(
                            icon: "clock",
                            title: "Time",
                            value: appointment.startDate.formatted(date: .omitted, time: .shortened)
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                .padding(.horizontal)

                Spacer(minLength: 20)

                // Cancel Button
                Button(action: {
                    showingCancelAlert = true
                }) {
                    Text("Cancel Appointment")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(UIColor.systemGray6))
        .alert("Cancel Appointment", isPresented: $showingCancelAlert) {
            Button("Yes, Cancel", role: .destructive) {
                Task {
                    await cancelAppointment()
                }
            }
            Button("No", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel this appointment?")
        }
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Failed to cancel the appointment. Please try again.")
        }
    }

    func cancelAppointment() async {
        let cancelled = await DataController.shared.cancelAppointment(appointment)
        if cancelled {
            delegate?.refreshAppointments()
            DispatchQueue.main.async {
                dismiss()
            }
        }
    }
}

// MARK: - Supporting Views

struct AppointmentDetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 17))
            }

            Spacer()
        }
    }
}
