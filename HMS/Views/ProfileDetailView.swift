import SwiftUI
import UIKit
import PhotosUI

struct ProfileDetailView: View {
    @State var patient: Patient?
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isEditing = false
    @State private var editedFullName = ""
    @State private var editedEmail = ""
    @State private var editedDateOfBirth: Date = .init()
    @State private var selectedGender = "Male"
    @State private var selectedBloodGroup = "A+"
    @State private var editedHeight = ""
    @State private var editedWeight = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    var delegate: ProfileHostingController?

    var body: some View {
        List {
            // Profile Image Section
            Section {
                VStack(spacing: 8) {
                    ZStack(alignment: .bottomTrailing) {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .foregroundColor(Color(.systemGray4))
                        }

                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(.blue)
                        }
                    }

                    Text(patient?.fullName ?? "")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowBackground(Color(.systemGroupedBackground))
            }
            .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))

            // Personal Information Section
            Section {
                if isEditing {
                    TextField("Full Name", text: $editedFullName)
                        .foregroundColor(.primary)
                    TextField("Email", text: $editedEmail)
                        .foregroundColor(.primary)
                    DatePicker("Date of Birth", selection: $editedDateOfBirth, in: ...Date(), displayedComponents: .date)
                    Picker("Gender", selection: $selectedGender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Other").tag("Other")
                    }
                    Picker("Blood Group", selection: $selectedBloodGroup) {
                        Text("A+").tag("A+")
                        Text("A-").tag("A-")
                        Text("B+").tag("B+")
                        Text("B-").tag("B-")
                        Text("AB+").tag("AB+")
                        Text("AB-").tag("AB-")
                        Text("O+").tag("O+")
                        Text("O-").tag("O-")
                    }
                } else {
                    InfoRowView(title: "Full Name", value: patient?.fullName ?? "-", icon: "person")
                    InfoRowView(title: "Email", value: patient?.emailAddress ?? "-", icon: "envelope")
                    InfoRowView(title: "Date of Birth", value: formatDate(patient?.dateOfBirth), icon: "calendar")
                    InfoRowView(title: "Gender", value: patient?.gender.rawValue ?? "-", icon: "person.2")
                    InfoRowView(title: "Blood Group", value: patient?.bloodGroup.rawValue ?? "-", icon: "drop")
                }
            } header: {
                HStack(spacing: 6) {
                    Image(systemName: "person")
                        .foregroundColor(Color(.systemGray))
                    Text("PERSONAL INFORMATION")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(.systemGray))
                }
                .padding(.bottom, 8)
            }
            .listSectionSpacing(24)

            // Health Information Section
            Section {
                if isEditing {
                    HStack {
                        TextField("Height", text: $editedHeight)
                            .keyboardType(.numberPad)
                            .foregroundColor(.primary)
                        Text("cm")
                            .foregroundColor(.primary)
                    }
                    HStack {
                        TextField("Weight", text: $editedWeight)
                            .keyboardType(.numberPad)
                            .foregroundColor(.primary)
                        Text("kg")
                            .foregroundColor(.primary)
                    }
                } else {
                    InfoRowView(title: "Height", value: "\(patient?.height ?? 0) cm", icon: "ruler")
                    InfoRowView(title: "Weight", value: "\(patient?.weight ?? 0) kg", icon: "scalemass")
                }
            } header: {
                HStack(spacing: 6) {
                    Image(systemName: "heart")
                        .foregroundColor(Color(.systemGray))
                    Text("HEALTH INFORMATION")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(.systemGray))
                }
                .padding(.bottom, 8)
            }
            .listSectionSpacing(24)

            // Account Section
            Section {
                Button(action: {
                    delegate?.showChangePassword()
                }) {
                    HStack {
                        Image(systemName: "lock")
                            .frame(width: 24)
                            .foregroundColor(.primary)
                        Text("Change Password")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(.systemGray))
                    }
                }

                Button(action: {
                    delegate?.logout()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .frame(width: 24)
                            .foregroundColor(Color("errorBlue"))
                        Text("Logout")
                            .foregroundColor(Color("errorBlue"))
                        Spacer()
                    }
                }
            } header: {
                HStack(spacing: 6) {
                    Image(systemName: "person.circle")
                        .foregroundColor(Color(.systemGray))
                    Text("ACCOUNT")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(.systemGray))
                }
                .padding(.bottom, 8)
            }
            .listSectionSpacing(24)
        }
        .listStyle(InsetGroupedListStyle())
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
        .navigationBarItems(trailing: Button(action: {
            if isEditing {
                saveChanges()
            }
            isEditing.toggle()
        }) {
            Text(isEditing ? "Save" : "Edit")
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Update Profile"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            // Update patient data when view appears
            if let currentPatient = DataController.shared.patient {
                patient = currentPatient
                initializeEditingValues()
            }
        }
    }

    private func initializeEditingValues() {
        guard let patient else { return }
        editedFullName = patient.fullName ?? ""
        editedEmail = patient.emailAddress
        editedDateOfBirth = patient.dateOfBirth
        selectedGender = patient.gender.rawValue
        selectedBloodGroup = patient.bloodGroup.rawValue
        editedHeight = "\(patient.height)"
        editedWeight = "\(patient.weight)"
    }

    private func saveChanges() {
        Task {
            do {
                // Create dictionary of updated values
                let updatedValues: [String: Any] = [
                    "fullName": editedFullName,
                    "emailAddress": editedEmail,
                    "dateOfBirth": editedDateOfBirth,
                    "gender": selectedGender,
                    "bloodGroup": selectedBloodGroup,
                    "height": Int(editedHeight) ?? 0,
                    "weight": Int(editedWeight) ?? 0
                ]

                // Call API to update patient
                if let success = try? await DataController.shared.updatePatient(with: updatedValues) {
                    if success {
                        alertMessage = "Profile updated successfully"
                        // Refresh patient data
                        patient = DataController.shared.patient
                    } else {
                        alertMessage = "Failed to update profile"
                    }
                } else {
                    alertMessage = "Error occurred while updating profile"
                }
                showAlert = true
            }
        }
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
