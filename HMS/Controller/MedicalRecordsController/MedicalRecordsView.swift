//
//  MedicalRecordsView.swift
//  HMS
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

struct MedicalReport: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case description
        case date
        case type
        case imageData = "image_data"
    }

    var id: String = UUID().uuidString
    var description: String
    var date: Date
    var type: String
    var imageData: Data?

    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}

struct MedicalRecordsView: View {

    // MARK: Internal

    weak var delegate: MedicalRecordsHostingController?

    var body: some View {
        VStack(spacing: 0) {
            // Filter Section
            VStack(spacing: 16) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search by description", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Date Filter
                HStack {
                    DatePicker("From", selection: $startDate, in: ...Date(), displayedComponents: .date)
                        .labelsHidden()
                    Text("-")
                    DatePicker("To", selection: $endDate, in: ...Date(), displayedComponents: .date)
                        .labelsHidden()
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            .background(Color.white)
            
            if filteredReports.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No records found for the selected criteria")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                List {
                    ForEach(filteredReports) { report in
                        MedicalRecordRow(title: report.description, date: report.date.humanReadableString(), type: report.type, report: report)
                            .listRowBackground(Color(.systemGroupedBackground))
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color(.systemGroupedBackground))
                .scrollContentBackground(.hidden)
            }
        }
        .task {
            await loadReports()
        }
        .onAppear {
            Task {
                await loadReports()
            }
        }
    }

    // MARK: Private

    @State private var reports: [MedicalReport] = []
    @State private var searchText = ""
    @State private var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate = Date()

    private var filteredReports: [MedicalReport] {
        reports.filter { report in
            let matchesSearch = searchText.isEmpty || 
                report.description.localizedCaseInsensitiveContains(searchText) ||
                report.type.localizedCaseInsensitiveContains(searchText)
            
            let matchesDate = report.date >= startDate && report.date <= endDate
            
            return matchesSearch && matchesDate
        }
        .sorted { $0.date > $1.date }
    }

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
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                // Icon with background
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    )

                VStack(alignment: .leading, spacing: 12) {
                    // Title and Date
                    HStack(alignment: .center) {
                        Text(title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text(date)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }

                    // Department/Type with icon
                    HStack(spacing: 6) {
                        Image(systemName: "stethoscope")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text(type)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }

                    // Status and View Report
                    HStack {
                        // Status with improved styling
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            Text("Completed")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)

                        Spacer()

                        // View Report Button
                        NavigationLink {
                            MedicalReportDetailView(report: report)
                        } label: {
                            Text("")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
        }
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

