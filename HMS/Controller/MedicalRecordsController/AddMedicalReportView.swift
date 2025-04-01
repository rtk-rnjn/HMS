//
//  AddMedicalReportView.swift
//  HMS
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI
import PhotosUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        // MARK: Lifecycle

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // MARK: Internal

        let parent: ImagePicker

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }

            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    @Binding var selectedImage: UIImage?

    let sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

}

struct AddMedicalReportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedReportType: String = ""
    @State private var description: String = ""
    @State private var reportDate: Date = .init()
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingSourceTypeSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isSaving = false
    @State private var showError = false
    @State private var showSuccess = false

    var onSave: ((MedicalReport) -> Void)?

    let reportTypes = [
        "Lab Report",
        "Check-up Report",
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
                Button("OK", role: .cancel) {}
            } message: {
                Text("Failed to save the medical report. Please try again.")
            }
            .alert("Success", isPresented: $showSuccess) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Medical report has been successfully added.")
            }
        }
    }

    private func saveReport() async {
        isSaving = true
        let report = MedicalReport(description: description, date: reportDate, type: selectedReportType, imageData: selectedImage?.pngData())
        
        do {
            let success = await DataController.shared.createMedicalReport(report)
            DispatchQueue.main.async {
                isSaving = false
                if success {
                    showSuccess = true
                } else {
                    showError = true
                }
            }
        } catch {
            DispatchQueue.main.async {
                isSaving = false
                showError = true
            }
        }
    }
}
