import SwiftUI

struct AddMedicalReportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedReportType: String = ""
    @State private var description: String = ""
    @State private var reportDate = Date()
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingSourceTypeSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isSaving = false
    @State private var showError = false
    
    var onSave: ((MedicalReport) -> Void)?
    
    let reportTypes = [
        "Lab Report",
        "Check-up Report",
        "Radiology",
        "Prescription",
        "Vaccination Record",
        "Surgery Report",
        "Other"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 24) {
                            // Report Type
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Report Type")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Menu {
                                    ForEach(reportTypes, id: \.self) { type in
                                        Button(type) {
                                            selectedReportType = type
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedReportType.isEmpty ? "Select report type" : selectedReportType)
                                            .foregroundColor(selectedReportType.isEmpty ? .gray : .primary)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                }
                            }
                            
                            // Description
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextEditor(text: $description)
                                    .frame(height: 120)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(.systemGray4), lineWidth: 1)
                                    )
                            }
                            
                            // Report Date
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Report Date")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    DatePicker(
                                        "",
                                        selection: $reportDate,
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    
                                    Spacer()
                                    
                                    Image(systemName: "calendar")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                            }
                            
                            // Attachments
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Attachments")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Button(action: {
                                    showingSourceTypeSheet = true
                                }) {
                                    VStack(spacing: 12) {
                                        if let selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxHeight: 200)
                                                .cornerRadius(8)
                                        } else {
                                            Image(systemName: "arrow.up.doc")
                                                .font(.system(size: 24))
                                                .foregroundColor(.blue)
                                            
                                            Text("Upload files")
                                                .font(.subheadline)
                                                .foregroundColor(.blue)
                                            
                                            Text("PDF, JPG, PNG up to 10MB")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 24)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                            .foregroundColor(Color(.systemGray4))
                                    )
                                }
                            }
                            
                            // Submit Button
                            Button(action: {
                                Task {
                                    await saveReport()
                                }
                            }) {
                                if isSaving {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Submit Report")
                                        .font(.headline)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .disabled(selectedReportType.isEmpty || description.isEmpty || isSaving)
                            .padding(.top, 24)
                        }
                        .padding(20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add Medical Report")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
            }
            .actionSheet(isPresented: $showingSourceTypeSheet) {
                ActionSheet(
                    title: Text("Add Medical Record"),
                    message: Text("Choose a source"),
                    buttons: [
                        .default(Text("Camera")) {
                            sourceType = .camera
                            showingImagePicker = true
                        },
                        .default(Text("Photo Library")) {
                            sourceType = .photoLibrary
                            showingImagePicker = true
                        },
                        .cancel()
                    ]
                )
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Failed to save the medical report. Please try again.")
            }
        }
    }
    
    private func saveReport() async {
        isSaving = true
        defer { isSaving = false }
        
        var attachmentURL: String? = nil
        if let image = selectedImage {
            attachmentURL = await DataController.shared.uploadImage(image)
        }
        
        let report = MedicalReport(
            reportType: selectedReportType,
            description: description,
            reportDate: reportDate,
            attachmentURL: attachmentURL
        )
        
        let success = await DataController.shared.saveMedicalReport(report)
        if success {
            onSave?(report)
            dismiss()
        } else {
            showError = true
        }
    }
} 
