import SwiftUI

struct BasicInfoCard: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                Text(title)
                    .foregroundColor(.gray)
            }
            HStack(alignment: .firstTextBaseline) {
                Text(value)
                    .font(.system(size: 32, weight: .bold))
                Text(unit)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct MedicalRecordRow: View {
    let date: String
    let condition: String
    let doctor: String
    let notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(date)
                    .foregroundColor(.gray)
                Spacer()
                Text(doctor)
                    .foregroundColor(.blue)
            }
            Text(condition)
                .font(.title2)
                .fontWeight(.bold)
            Text(notes)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct PatientDetailsView: View {
    let patient: Patient
    @State private var selectedTab = "Records"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Image and Name
                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    Text(patient.fullName ?? "Unknown")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                // Basic Information
                VStack(alignment: .leading, spacing: 16) {
                    InfoRow(title: "Age", value: "\(Calendar.current.dateComponents([.year], from: patient.dateOfBirth, to: Date()).year ?? 0) years")
                    InfoRow(title: "Gender", value: patient.gender.rawValue)
                    InfoRow(title: "Phone", value: "+1 (555) 123-4567")
                }
                .padding(.horizontal)
                
                // Basic Info Cards
                Text("Basic Info")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                HStack(spacing: 12) {
                    BasicInfoCard(icon: "drop.fill", title: "Blood Type", value: patient.bloodGroup.rawValue, unit: "")
                    BasicInfoCard(icon: "scalemass.fill", title: "Weight", value: "\(patient.weight)", unit: "kg")
                    BasicInfoCard(icon: "ruler.fill", title: "Height", value: "\(patient.height)", unit: "cm")
                }
                .padding(.horizontal)
                
                // Records Tabs
                HStack {
                    ForEach(["Records", "Medications", "Lab Results", "Notes"], id: \.self) { tab in
                        Button(action: {
                            selectedTab = tab
                        }) {
                            Text(tab)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedTab == tab ? Color.white : Color.clear)
                                .foregroundColor(selectedTab == tab ? .black : .gray)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(25)
                .padding(.horizontal)
                
                // Medical Records
                if selectedTab == "Records" {
                    MedicalRecordRow(
                        date: "21 Mar 2025",
                        condition: "Common Cold",
                        doctor: "Dr. Smith",
                        notes: "Rest and hydration"
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationView {
        PatientDetailsView(patient: Patient(
            firstName: "John",
            lastName: "Doe",
            emailAddress: "john@example.com",
            password: "password",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -42, to: Date())!,
            gender: .male,
            bloodGroup: .aPositive,
            height: 168,
            weight: 65
        ))
    }
} 