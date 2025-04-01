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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Profile Card
                VStack(spacing: 16) {
                    // Profile Image
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .foregroundColor(.white)
                        
                        // Camera Icon
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            )
                            .offset(x: 35, y: 35)
                    }
                    .padding(.top, 20)
                    
                    // Doctor Name and Specialization
                    VStack(spacing: 4) {
                        Text(appointment.doctor?.fullName ?? "Doctor Name")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(appointment.doctor?.specialization ?? "Specialist")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Stats Card
                HStack(spacing: 0) {
                    // Patients
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "person.3.fill")
                                .foregroundColor(.blue)
                            Text("1.2k")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        Text("Patients")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Divider
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 1, height: 40)
                    
                    // Experience
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                            Text("8+ yrs")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        Text("Experience")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Divider
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 1, height: 40)
                    
                    // Rating
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.blue)
                            Text("4.8")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        Text("Rating")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Appointment Details Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Appointment Details")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                        Text(appointment.startDate.formatted(date: .long, time: .omitted))
                            .font(.body)
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                        Text(appointment.startDate.formatted(date: .omitted, time: .shortened))
                            .font(.body)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                Spacer()
                
                // Cancel Button
                Button(action: {
                    showingCancelAlert = true
                }) {
                    Text("Cancel Appointment")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
        }
        .background(Color(.systemGroupedBackground))
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
        if let success = try? await DataController.shared.deleteAppointment(appointment.id) {
            if success {
                delegate?.refreshAppointments()
                dismiss()
            } else {
                showingErrorAlert = true
            }
        } else {
            showingErrorAlert = true
        }
    }
} 