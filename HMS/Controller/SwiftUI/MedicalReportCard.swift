//
//  MedicalReportCard.swift
//  HMS
//
//  Created by RITIK RANJAN on 01/04/25.
//

import SwiftUI

struct MedicalReportCard: View {
    let report: MedicalReport

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = report.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12)
            }

            Text(report.type)
                .font(.headline)
                .foregroundColor(.blue)

            Text(report.description)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(3)
                .truncationMode(.tail)

            Text(report.date, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
