import SwiftUI

struct MedicalReportDetailView: View {
    let report: MedicalReport
    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Report Details Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(report.reportType)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Text(report.reportDate.formatted(date: .long, time: .omitted))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Status")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Normal")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    
                    HStack {
                        Text("Doctor")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Dr. Sarah Wilson")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Department")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Hematology Department")
                            .fontWeight(.medium)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                // Key Test Results Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    TestResultCard(
                        title: "Hemoglobin",
                        value: "14.2 g/dL",
                        range: "13.5-17.5"
                    )
                    TestResultCard(
                        title: "Platelets",
                        value: "250K/μL",
                        range: "150-450"
                    )
                    TestResultCard(
                        title: "WBC",
                        value: "7.8K/μL",
                        range: "4.5-11.0"
                    )
                    TestResultCard(
                        title: "RBC",
                        value: "5.2M/μL",
                        range: "4.5-5.9"
                    )
                }
                
                // Detailed Test Results
                VStack(alignment: .leading, spacing: 16) {
                    Text("Detailed Test Results")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ForEach(testParameters, id: \.parameter) { parameter in
                            HStack {
                                Text(parameter.parameter)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(parameter.result)
                                    .fontWeight(.medium)
                                Text(parameter.range)
                                    .foregroundColor(.secondary)
                                    .frame(width: 100)
                                Circle()
                                    .fill(parameter.isNormal ? Color.green : Color.red)
                                    .frame(width: 8, height: 8)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            
                            if parameter.parameter != testParameters.last?.parameter {
                                Divider()
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                }
                
                // Doctor's Notes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Doctor's Notes")
                        .font(.headline)
                    
                    Text("All blood parameters are within normal ranges. Continue with current diet and exercise routine. Follow-up recommended in 6 months for routine check.")
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        // Handle download PDF
                    }) {
                        HStack {
                            Image(systemName: "arrow.down.doc")
                            Text("Download PDF")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Handle print
                    }) {
                        HStack {
                            Image(systemName: "printer")
                            Text("Print Report")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            // Share sheet implementation
            Text("Share Report")
        }
    }
    
    private let testParameters = [
        TestParameter(parameter: "Hemoglobin", result: "14.2 g/dL", range: "13.5-17.5", isNormal: true),
        TestParameter(parameter: "Platelets", result: "250K/μL", range: "150-450", isNormal: true),
        TestParameter(parameter: "WBC", result: "7.8K/μL", range: "4.5-11.0", isNormal: true),
        TestParameter(parameter: "RBC", result: "5.2M/μL", range: "4.5-5.9", isNormal: true),
        TestParameter(parameter: "Hematocrit", result: "42%", range: "38.8-50", isNormal: true),
        TestParameter(parameter: "MCV", result: "90 fL", range: "80-100", isNormal: true)
    ]
}

struct TestResultCard: View {
    let title: String
    let value: String
    let range: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Range: \(range)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct TestParameter {
    let parameter: String
    let result: String
    let range: String
    let isNormal: Bool
} 