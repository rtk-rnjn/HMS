//

//

//

import SwiftUI

struct MedicalReportDetailView: View {

    // MARK: Internal

    let report: MedicalReport

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(report.type)
                    .font(.system(size: 28, weight: .bold))
                Spacer()
            }

            Text(report.date.formatted(date: .complete, time: .shortened))
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
    }

    var doctorNotesSection: some View {
        Group {
            if !report.description.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "text.quote")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                        Text("Doctor's Notes")
                            .font(.system(size: 20, weight: .semibold))
                    }

                    Text(report.description)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)
            }
        }
    }

    var imageSection: some View {
        Group {
            if let image = report.image {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                        Text("Report Image")
                            .font(.system(size: 20, weight: .semibold))
                    }

                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                            .onAppear { isImageLoading = false }

                        if isImageLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.5)
                                .frame(height: 200)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
            }
        }
    }

    var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "info.circle")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                Text("Additional Information")
                    .font(.system(size: 20, weight: .semibold))
            }

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                InfoCell(title: "Report Type", value: report.type)
                InfoCell(title: "Created", value: report.date.formatted(date: .abbreviated, time: .shortened))
                InfoCell(title: "Status", value: "Completed", color: .green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                headerSection
                doctorNotesSection
                imageSection
                additionalInfoSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    shareItems = prepareShareContent()
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: shareItems)
        }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []
    @State private var showingDeleteAlert = false
    @State private var isImageLoading = true

    private func prepareShareContent() -> [Any] {
        var items: [Any] = []

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short

        let reportText = """
        Medical Report

        Type: \(report.type)
        Date: \(dateFormatter.string(from: report.date))
        Status: Completed

        Doctor's Notes:
        \(report.description)
        """

        items.append(reportText)

        if let image = report.image {
            items.append(image)
        }

        return items
    }

    private func deleteReport() {

        dismiss()
    }

}

struct InfoCell: View {
    let title: String
    let value: String
    var color: Color = .primary

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
