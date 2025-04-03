import SwiftUI

struct ProfileDetailView: View {
    @State var patient: Patient?
    var delegate: ProfileHostingController?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Image Section
                VStack(spacing: 12) {
                    ZStack(alignment: .bottomTrailing) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            // Edit profile picture functionality can be added here
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Text(patient?.fullName ?? "")
                        .font(.title2)
                        .bold()
                }
                .padding(.top, 20)
                
                // Personal Information Section
                GroupBox(label: Label("Personal Information", systemImage: "person.fill")) {
                    VStack(spacing: 0) {
                        InfoRowView(title: "Full Name", value: patient?.fullName ?? "-")
                        Divider()
                        InfoRowView(title: "Email", value: patient?.emailAddress ?? "-")
                        Divider()
                        InfoRowView(title: "Date of Birth", value: formatDate(patient?.dateOfBirth))
                        Divider()
                        InfoRowView(title: "Gender", value: patient?.gender.rawValue ?? "-")
                        Divider()
                        InfoRowView(title: "Blood Group", value: patient?.bloodGroup.rawValue ?? "-")
                    }
                }
                
                // Health Information Section
                GroupBox(label: Label("Health Information", systemImage: "heart.fill")) {
                    VStack(spacing: 0) {
                        InfoRowView(title: "Height", value: "\(patient?.height ?? 0) cm")
                        Divider()
                        InfoRowView(title: "Weight", value: "\(patient?.weight ?? 0) kg")
                    }
                }
                
                // Buttons Section
                VStack(spacing: 12) {
                    Button(action: {
                        delegate?.performSegue(withIdentifier: "segueShowChangePasswordTableViewController", sender: nil)
                    }) {
                        Text("Change Password")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        delegate?.logout()
                    }) {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            // Update patient data when view appears
            if let currentPatient = DataController.shared.patient {
                patient = currentPatient
            }
        }
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}






