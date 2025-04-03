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
    @StateObject private var viewModel = AddMedicalReportViewModel()
    var onAdd: (() -> Void)?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Report Type Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Report Type")
                            .font(.system(size: 17, weight: .semibold))
                        
                        Menu {
                            ForEach(ReportType.allCases, id: \.self) { type in
                                Button(action: {
                                    viewModel.selectedType = type
                                }) {
                                    Text(type.rawValue)
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.selectedType?.rawValue ?? "Select report type")
                                    .foregroundColor(viewModel.selectedType == nil ? .secondary : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }
                    }
                    
                    // Status Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(viewModel.status.color)
                            Text("Status")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        
                        Menu {
                            ForEach(ReportStatus.allCases, id: \.self) { status in
                                Button(action: {
                                    viewModel.status = status
                                }) {
                                    HStack {
                                        Circle()
                                            .fill(status.color)
                                            .frame(width: 8, height: 8)
                                        Text(status.rawValue)
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Circle()
                                    .fill(viewModel.status.color)
                                    .frame(width: 8, height: 8)
                                Text(viewModel.status.rawValue)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }
                    }
                    
                    // Description Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "text.quote")
                                .foregroundColor(.blue)
                            Text("Doctor's Notes")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        
                        TextEditor(text: $viewModel.description)
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                    
                    // Report Date Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Report Date")
                            .font(.system(size: 17, weight: .semibold))
                        
                        DatePicker("", selection: $viewModel.date, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                    
                    // Attachments Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "photo")
                                .foregroundColor(.blue)
                            Text("Attachments")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        
                        if let selectedImage = viewModel.selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(10)
                        }
                        
                        PhotosPicker(selection: $viewModel.imageSelection,
                                   matching: .images) {
                            HStack {
                                Image(systemName: "arrow.up.doc")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading) {
                                    Text("Upload files")
                                        .foregroundColor(.blue)
                                    Text("PDF, JPG, PNG up to 10MB")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .foregroundColor(.secondary)
                            )
                        }
                    }
                    
                    // Submit Button
                    Button(action: {
                        Task {
                            if await viewModel.submitReport() {
                                onAdd?()
                                dismiss()
                            }
                        }
                    }) {
                        Text("Submit Report")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isValid ? Color.blue : Color.blue.opacity(0.5))
                            .cornerRadius(10)
                    }
                    .disabled(!viewModel.isValid)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Medical Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// ViewModel
class AddMedicalReportViewModel: ObservableObject {
    @Published var selectedType: ReportType?
    @Published var description = ""
    @Published var date = Date()
    @Published var status: ReportStatus = .pending
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet { Task { await loadImage() } }
    }
    @Published var selectedImage: UIImage?
    
    var isValid: Bool {
        selectedType != nil && !description.isEmpty
    }
    
    @MainActor
    private func loadImage() async {
        guard let imageSelection else { return }
        do {
            let data = try await imageSelection.loadTransferable(type: Data.self)
            guard let data, let image = UIImage(data: data) else { return }
            selectedImage = image
        } catch {
            print("Error loading image: \(error)")
        }
    }
    
    func submitReport() async -> Bool {
        guard let type = selectedType?.rawValue else { return false }
        
        let report = MedicalReport(
            description: description,
            date: date,
            type: type,
            imageData: selectedImage?.pngData()
        )
        
        return await DataController.shared.createMedicalReport(report)
    }
}

// Report Types
enum ReportType: String, CaseIterable {
    case labReport = "Lab Report"
    case prescription = "Prescription"
    case diagnosis = "Diagnosis"
    case imaging = "Imaging"
    case vaccination = "Vaccination"
    case other = "Other"
}

// Report Status
enum ReportStatus: String, CaseIterable {
    case completed = "Completed"
    case pending = "Pending"
    case inProgress = "In Progress"
    case cancelled = "Cancelled"
    
    var color: Color {
        switch self {
        case .completed: return .green
        case .pending: return .orange
        case .inProgress: return .blue
        case .cancelled: return .red
        }
    }
}
