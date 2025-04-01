//
//  MedicalReportDetailView.swift
//  HMS
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

struct MedicalReportDetailView: View {

    // MARK: Internal

    let report: MedicalReport

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(report.type)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Text(report.date.humanReadableString())
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)

                imageData()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Doctor's Notes")
                        .font(.headline)

                    Text(report.description)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)

            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false

    private func imageData() -> some View {
        guard let data = report.imageData else {
            return AnyView(EmptyView())
        }

        return AnyView(
            VStack(alignment: .leading, spacing: 8) {
                Text("Report Image")
                    .font(.headline)

                Image(uiImage: UIImage(data: data)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}
