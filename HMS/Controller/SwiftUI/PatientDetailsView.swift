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

struct PatientDetailsView: View {

    // MARK: Internal

    let patient: Patient

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

                if selectedTab == "Records" {
                    MedicalRecordRow(title: "Common Cold", date: Date().humanReadableString(), type: "", report: MedicalReport(description: "Common Cold", date: Date(), type: ""))
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Private

    @State private var selectedTab = "Records"

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
