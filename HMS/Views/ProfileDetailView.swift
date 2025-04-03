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
    @State private var editedDateOfBirth = Date()
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
                VStack(spacing: 4) {
                    ZStack(alignment: .bottomTrailing) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Text(patient?.fullName ?? "")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color(.systemGroupedBackground))
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            
            // Personal Information Section
            Section {
                if isEditing {
                    TextField("Full Name", text: $editedFullName)
                    TextField("Email", text: $editedEmail)
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
                    InfoRowView(title: "Full Name", value: patient?.fullName ?? "-")
                    InfoRowView(title: "Email", value: patient?.emailAddress ?? "-")
                    InfoRowView(title: "Date of Birth", value: formatDate(patient?.dateOfBirth))
                    InfoRowView(title: "Gender", value: patient?.gender.rawValue ?? "-")
                    InfoRowView(title: "Blood Group", value: patient?.bloodGroup.rawValue ?? "-")
                }
            } header: {
                Label("Personal Information", systemImage: "person.fill")
                    .foregroundColor(.gray)
                    .textCase(nil)
                    .font(.system(size: 16, weight: .regular))
            }
            
            // Health Information Section
            Section {
                if isEditing {
                    HStack {
                        TextField("Height", text: $editedHeight)
                            .keyboardType(.numberPad)
                        Text("cm")
                    }
                    HStack {
                        TextField("Weight", text: $editedWeight)
                            .keyboardType(.numberPad)
                        Text("kg")
                    }
                } else {
                    InfoRowView(title: "Height", value: "\(patient?.height ?? 0) cm")
                    InfoRowView(title: "Weight", value: "\(patient?.weight ?? 0) kg")
                }
            } header: {
                Label("Health Information", systemImage: "heart.fill")
                    .foregroundColor(.gray)
                    .textCase(nil)
                    .font(.system(size: 16, weight: .regular))
            }
            
            // Buttons Section
            Section {
                Button(action: {
                    delegate?.showChangePassword()
                }) {
                    HStack {
                        Spacer()
                        Text("Change Password")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                
                Button(action: {
                    delegate?.logout()
                }) {
                    HStack {
                        Spacer()
                        Text("Logout")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Color.red)
                    .cornerRadius(8)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            }
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
        guard let patient = patient else { return }
        editedFullName = patient.fullName ?? ""
        editedEmail = patient.emailAddress ?? ""
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
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
} 