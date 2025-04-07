//

//

//

import SwiftUI
import PhotosUI
import UIKit

struct AddMedicalReportView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddMedicalReportViewModel = .init()
    var onAdd: (() -> Void)?
    
    // Add missing state variables
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Report Type")
                            .font(.headline)
                            
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "text.quote")
                                .foregroundColor(.blue)
                            Text("Description")
                                .font(.headline)
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Report Date")
                            .font(.headline)
                            
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "photo")
                                .foregroundColor(.blue)
                            Text("Attachments")
                                .font(.headline)
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
                                    Text("JPG or PNG")
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
                    
                    Button(action: {
                        Task {
                            await submitReport()
                        }
                    }) {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.5))
                                .cornerRadius(10)
                        } else {
                            Text("Submit Report")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.isValid ? Color.blue : Color.blue.opacity(0.5))
                                .cornerRadius(10)
                        }
                    }
                    .disabled(!viewModel.isValid || viewModel.isSubmitting)
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
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {
                    dismissWithSuccess()
                }
            } message: {
                Text("Medical report has been added successfully!")
            }
        }
    }
    
    // Handles the submission of the report
    private func submitReport() async {
        viewModel.isSubmitting = true
        
        do {
            // Create the report
            let reportID = UUID().uuidString
            let report = MedicalReport(
                id: reportID,
                description: viewModel.description,
                date: viewModel.date,
                type: viewModel.selectedType?.rawValue ?? "Other",
                imageData: viewModel.selectedImage?.jpegData(compressionQuality: 0.5),
                status: "Completed"
            )
            
            // Save to UserDefaults immediately for instant display
            saveReportToUserDefaults(report)
            viewModel.submittedReport = report
            
            // Post notification immediately so UI updates 
            // before showing success alert or dismissing view
            postNotificationForReport(report)
            
            // Show success after UI has been updated
            await MainActor.run {
                showSuccessAlert = true
            }
            
            // Send to backend in background
            Task.detached {
                do {
                    let success = await viewModel.submitReport(report)
                    print("Background submission result: \(success)")
                } catch {
                    print("Background submission failed: \(error)")
                    // We already saved locally, so no need to alert the user
                }
            }
        } catch {
            alertTitle = "Error"
            alertMessage = "An error occurred: \(error.localizedDescription)"
            showAlert = true
        }
        
        viewModel.isSubmitting = false
    }
    
    // Posts a notification for a newly added report
    private func postNotificationForReport(_ report: MedicalReport) {
        let userInfo: [String: Any] = [
            "report": [
                "id": report.id,
                "description": report.description,
                "type": report.type,
                "date": report.date
            ]
        ]
        
        // Post notification for immediate UI update
        NotificationCenter.default.post(
            name: NSNotification.Name("MedicalReportAdded"),
            object: nil,
            userInfo: userInfo
        )
    }
    
    // Handles dismissal after successful report submission
    private func dismissWithSuccess() {
        // Call the onAdd callback if provided - this will trigger UI refresh in parent view
        onAdd?()
        
        // Dismiss the view
        dismiss()
    }
    
    // Save report directly to UserDefaults
    private func saveReportToUserDefaults(_ report: MedicalReport) {
        // First get existing reports
        var reports = loadExistingReports()
        
        // Add the new report at the beginning
        reports.insert(report, at: 0)
        
        // Save back to UserDefaults
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(reports)
            UserDefaults.standard.set(data, forKey: "MedicalReportsCache")
        } catch {
            print("Failed to save report to UserDefaults: \(error)")
        }
    }
    
    // Load existing reports from UserDefaults
    private func loadExistingReports() -> [MedicalReport] {
        guard let data = UserDefaults.standard.data(forKey: "MedicalReportsCache") else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let reports = try decoder.decode([MedicalReport].self, from: data)
            return reports
        } catch {
            print("Failed to load reports from UserDefaults: \(error)")
            return []
        }
    }
}

class AddMedicalReportViewModel: ObservableObject {
    // MARK: Properties
    
    @Published var selectedType: ReportType?
    @Published var description = ""
    @Published var date: Date = .init()
    @Published var selectedImage: UIImage?
    @Published var isSubmitting: Bool = false
    @Published var submittedReport: MedicalReport?
    
    @Published var imageSelection: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    
    var isValid: Bool {
        selectedType != nil && !description.isEmpty
    }
    
    // Submit the already-created report to backend
    func submitReport(_ report: MedicalReport) async -> Bool {
        return await DataController.shared.createMedicalReport(report)
    }
    
    // Submit a new report to backend
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
    
    // MARK: Private
    
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
}

enum ReportType: String, CaseIterable {
    case labReport = "Lab Report"
    case diagnosis = "Diagnosis"
    case imaging = "Imaging"
    case vaccination = "Vaccination"
    case other = "Other"
}
