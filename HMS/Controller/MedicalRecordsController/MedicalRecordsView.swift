//
//  MedicalRecordsView.swift
//  HMS
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

struct MedicalRecordsView: View {

    // MARK: Internal

    weak var delegate: MedicalRecordsHostingController?

    var body: some View {
        List {
            ForEach(reports) { report in
                MedicalRecordRow(title: report.description, date: report.date.humanReadableString(), type: report.type, report: report)
                .listRowBackground(Color(.systemGroupedBackground))
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color(.systemGroupedBackground))
        .scrollContentBackground(.hidden)
        .task {
            await loadReports()
        }
    }

    // MARK: Private

    @State private var reports: [MedicalReport] = []

    private func loadReports() async {
        let fetchedReports = await DataController.shared.fetchMedicalReports()
        DispatchQueue.main.async {
            reports = fetchedReports
        }
    }
}

struct MedicalRecordRow: View {
    let title: String
    let date: String
    let type: String
    let report: MedicalReport

    var body: some View {
        NavigationLink(destination: MedicalReportDetailView(report: report)) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 16) {
                    // Icon
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                        .frame(width: 32)

                    VStack(alignment: .leading, spacing: 8) {
                        // Title and Date
                        HStack {
                            Text(title)
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            Text(date)
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }

                        // Department/Type
                        Text(type)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)

                        // Status and View Report
                        HStack {
                            // Status
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 8, height: 8)
                                Text("Completed")
                                    .font(.system(size: 14))
                                    .foregroundColor(.green)
                            }

                            Spacer()

                            // View Report Button
                            HStack(spacing: 4) {
                                Text("View Report")
                                    .font(.system(size: 16, weight: .medium))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
                .background(Color.white)
            }
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
