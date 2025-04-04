//

//

//

import SwiftUI

struct MedicalRecordRow: View {

    // MARK: Internal

    let title: String
    let date: String
    let type: String
    let report: MedicalReport

    var body: some View {
        NavigationLink(destination: MedicalReportDetailView(report: report)) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 16) {

                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 48, height: 48)
                            .colorInvert()

                        Image(systemName: getIconName(for: type))
                            .font(.title3)
                            .foregroundColor(.blue)
                    }

                    VStack(alignment: .leading, spacing: 12) {

                        HStack(alignment: .center) {
                            Text(type)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .lineLimit(1)

                            Spacer()

                            Text(date)
                                .font(.system(size: 14))
                                .foregroundColor(Color(.systemGray))
                        }

                        if !title.isEmpty {
                            Text(title)
                                .font(.footnote)
                                .foregroundColor(Color(.systemGray))
                                .lineLimit(2)
                        }

                        if let image = report.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }

    // MARK: Private

    private func getIconName(for type: String) -> String {
        switch type.lowercased() {
        case _ where type.contains("lab"):
            return "flask.fill"
        case _ where type.contains("check"):
            return "stethoscope"
        case _ where type.contains("vaccination"):
            return "cross.vial.fill"
        case _ where type.contains("surgery"):
            return "scissors"
        case _ where type.contains("prescription"):
            return "pills.fill"
        case _ where type.contains("diagnosis"):
            return "heart.text.square.fill"
        default:
            return "doc.text.fill"
        }
    }
}

struct FilterView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var selectedType: String?

    let reportTypes: [String]

    var body: some View {
        Form {
            Section(header: Text("Date Range")) {
                DatePicker("From", selection: $startDate, in: ...Date(), displayedComponents: .date)
                DatePicker("To", selection: $endDate, in: ...Date(), displayedComponents: .date)
            }

            Section(header: Text("Type")) {
                ForEach(reportTypes, id: \.self) { type in
                    Button(action: {
                        selectedType = selectedType == type ? nil : type
                    }) {
                        HStack {
                            Text(type)
                            Spacer()
                            if selectedType == type {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }

            Section {
                Button("Reset Filters") {
                    startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
                    endDate = Date()
                    selectedType = nil
                }
                .foregroundColor(Color("errorBlue"))
            }
        }
    }
}

struct MedicalRecordsView: View {

    // MARK: Internal

    weak var delegate: MedicalRecordsHostingController?

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                VStack(spacing: 16) {
                    HStack(spacing: 12) {

                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(.systemGray))
                                .font(.callout)
                            TextField("Search medical records", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.callout)
                            if !searchText.isEmpty {
                                Button(action: {
                                    withAnimation {
                                        searchText = ""
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color(.systemGray))
                                        .font(.callout)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )

                        Button(action: {
                            showingFilterSheet = true
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title2)
                                .foregroundColor(hasActiveFilters ? Color("selectedBlue") : Color("unselectedBlue"))
                                .overlay(
                                    Group {
                                        if !activeFiltersCount.isEmpty {
                                            Text(activeFiltersCount)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .padding(4)
                                                .background(Color.blue)
                                                .clipShape(Circle())
                                                .offset(x: 10, y: -10)
                                        }
                                    }
                                )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color(.systemBackground))

                if filteredReports.isEmpty {

                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(Color(.iconBlue))
                            .padding()

                        VStack(spacing: 8) {
                            Text("No Records Found")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.iconBlue)

                            Text("Try adjusting your search or filters")
                                .font(.body)
                                .foregroundColor(.unselectedBlue)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                    .transition(.opacity)
                } else {

                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredReports) { report in
                                MedicalRecordRow(title: report.description, date: report.date.humanReadableString(), type: report.type, report: report)
                                    .padding(.horizontal)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.vertical, 16)
                    }
                    .background(Color(.systemBackground))
                }
            }
        }
        .navigationTitle("Medical Records")
        .sheet(isPresented: $showingFilterSheet) {
            NavigationView {
                FilterView(
                    startDate: $startDate,
                    endDate: $endDate,
                    selectedType: $selectedType,
                    reportTypes: reportTypes
                )
                .navigationTitle("Filters")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingFilterSheet = false
                    },
                    trailing: Button("Done") {
                        showingFilterSheet = false
                    }
                )
            }
            .presentationDetents([.medium])
        }
        .task {
            delegate?.loadReports()
        }
        .refreshable {
            delegate?.loadReports()
        }
    }

    // MARK: Private

    var reports: [MedicalReport] = []
    @State private var searchText = ""
    @State private var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = .init()
    @State private var selectedType: String?
    @State private var showingFilterSheet = false

    private let reportTypes = [
        "Lab Report",
        "Check-up Report",
        "Vaccination Record",
        "Surgery Report",
        "Other"
    ]

    private var filteredReports: [MedicalReport] {
        reports.filter { report in
            let matchesSearch = searchText.isEmpty ||
                report.description.localizedCaseInsensitiveContains(searchText) ||
                report.type.localizedCaseInsensitiveContains(searchText)

            let matchesDate = report.date >= startDate && report.date <= endDate

            let matchesType = selectedType == nil || report.type == selectedType

            return matchesSearch && matchesDate && matchesType
        }
        .sorted { $0.date > $1.date }
    }

    private var hasActiveFilters: Bool {
        selectedType != nil ||
        !Calendar.current.isDate(startDate, inSameDayAs: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()) ||
        !Calendar.current.isDate(endDate, inSameDayAs: Date())
    }

    private var activeFiltersCount: String {
        var count = 0
        if selectedType != nil { count += 1 }
        if !Calendar.current.isDate(startDate, inSameDayAs: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()) { count += 1 }
        if !Calendar.current.isDate(endDate, inSameDayAs: Date()) { count += 1 }
        return count > 0 ? "\(count)" : ""
    }

    private func loadReports() async {
        delegate?.loadReports()
    }

    @Environment(\.mockDataController) private var _mockDataController
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.footnote)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.secondarySystemGroupedBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: 1)
                )
        }
    }
}

struct DateFilterButton: View {

    // MARK: Internal

    let title: String
    let date: Date
    let onDateChange: (Date) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray)

            Button(action: {
                showingDatePicker.toggle()
            }) {
                HStack {
                    Text(date.formatted(.dateTime.day().month().year()))
                        .font(.subheadline)
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showingDatePicker) {
            NavigationView {
                DatePickerView(selectedDate: date, onDateSelected: { newDate in
                    onDateChange(newDate)
                    showingDatePicker = false
                })
            }
            .presentationDetents([.height(420)])
        }
    }

    // MARK: Private

    @State private var showingDatePicker = false

}

struct DatePickerView: View {

    // MARK: Lifecycle

    init(selectedDate: Date, onDateSelected: @escaping (Date) -> Void) {
        self.selectedDate = selectedDate
        self.onDateSelected = onDateSelected
        _tempDate = State(initialValue: selectedDate)
    }

    // MARK: Internal

    let selectedDate: Date
    let onDateSelected: (Date) -> Void

    var body: some View {
        VStack(spacing: 0) {
            DatePicker(
                "Select Date",
                selection: $tempDate,
                in: ...Date(),
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()

            Divider()

            HStack(spacing: 20) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(Color("errorBlue"))

                Button("Done") {
                    onDateSelected(tempDate)
                }
                .fontWeight(.medium)
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    @State private var tempDate: Date

}

#if DEBUG
struct MedicalRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MedicalRecordsView()
        }
        .preferredColorScheme(.light)
        .environment(\.mockDataController, MockDataController())

        NavigationView {
            MedicalRecordsView()
        }
        .preferredColorScheme(.dark)
        .environment(\.mockDataController, MockDataController())
    }
}

// Sample Data Extension
extension MedicalReport {
    static var sampleReports: [MedicalReport] = [
        MedicalReport(
            description: "Complete Blood Count (CBC) Test Results",
            date: Date(),
            type: "Lab Report"
        ),
        MedicalReport(
            description: "Annual Physical Examination",
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            type: "Check-up Report"
        ),
        MedicalReport(
            description: "COVID-19 Booster Shot",
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            type: "Vaccination Record"
        ),
        MedicalReport(
            description: "Appendectomy Post-Operation Report",
            date: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(),
            type: "Surgery Report"
        ),
        MedicalReport(
            description: "Antibiotics for Upper Respiratory Infection",
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            type: "Prescription"
        )
    ]
}

class MockDataController: DataController {
    override func fetchMedicalReports() async -> [MedicalReport] {
        return MedicalReport.sampleReports
    }
}

private struct MockDataControllerKey: EnvironmentKey {
    static let defaultValue: DataController? = nil
}

extension EnvironmentValues {
    var mockDataController: DataController? {
        get { self[MockDataControllerKey.self] }
        set { self[MockDataControllerKey.self] = newValue }
    }
}
#endif
