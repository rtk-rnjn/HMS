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
                            if await viewModel.submitReport() {
                                onAdd?()
                                dismiss()
                            }
                        }
                    }) {
                        Text("Submit Report")
                            .font(.headline)
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

class AddMedicalReportViewModel: ObservableObject {

    // MARK: Internal

    @Published var selectedType: ReportType?
    @Published var description = ""
    @Published var date: Date = .init()
    @Published var selectedImage: UIImage?

    @Published var imageSelection: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }

    var isValid: Bool {
        selectedType != nil && !description.isEmpty
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
