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

                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                        Text("Loading medical records...")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else if filteredReports.isEmpty {
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
                    .refreshable {
                        await loadReports()
                    }
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
            await loadReports()
        }
        .onAppear {
            // Set up notification observer for report additions
            setupNotificationObserver()
            
            // Force refresh reports from UserDefaults when view appears
            Task {
                reports = loadReportsFromUserDefaults()
            }
        }
        .onDisappear {
            // Remove notification observer when view disappears
            NotificationCenter.default.removeObserver(notificationToken as Any)
        }
    }

    // MARK: Private

    @State var reports: [MedicalReport] = []
    @State private var searchText = ""
    @State private var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = .init()
    @State private var selectedType: String?
    @State private var showingFilterSheet = false
    @State private var isLoading = false
    @State private var notificationToken: NSObjectProtocol?

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
        isLoading = true
        
        // Load reports from UserDefaults instead of backend
        reports = loadReportsFromUserDefaults()
        
        // Only try to fetch from backend if UserDefaults is empty
        if reports.isEmpty {
            if let newReports = await delegate?.fetchReports() {
                reports = newReports
                saveReportsToUserDefaults(reports)
            }
        }
        
        isLoading = false
    }
    
    private func setupNotificationObserver() {
        // Remove any existing observer
        if let token = notificationToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        // Create a new observer without using weak self (MedicalRecordsView is a struct)
        notificationToken = NotificationCenter.default.addObserver(
            forName: NSNotification.Name("MedicalReportAdded"),
            object: nil,
            queue: .main
        ) { notification in
            // Process notification and update reports immediately
            if let reportData = notification.userInfo?["report"] as? [String: Any],
               let id = reportData["id"] as? String,
               let description = reportData["description"] as? String,
               let type = reportData["type"] as? String,
               let date = reportData["date"] as? Date {
                
                // Create temporary report from notification data
                let tempReport = MedicalReport(
                    id: id,
                    description: description,
                    date: date,
                    type: type,
                    imageData: nil,
                    status: "Completed"
                )
                
                // Update reports collection immediately on main thread
                // We're already on main thread from notification center, but being explicit
                DispatchQueue.main.async {
                    print("Notification received - updating reports collection with: \(tempReport.id)")
                    
                    // Only add if it doesn't already exist
                    if !self.reports.contains(where: { $0.id == tempReport.id }) {
                        // Create a new array and insert at beginning for better SwiftUI state handling
                        var updatedReports = self.reports
                        updatedReports.insert(tempReport, at: 0)
                        
                        // Trigger UI update with animation
                        withAnimation(.spring()) {
                            self.reports = updatedReports
                        }
                    }
                }
            }
        }
    }
    
    // Helper to save reports to UserDefaults
    private func saveReportsToUserDefaults(_ reports: [MedicalReport]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(reports)
            UserDefaults.standard.set(data, forKey: "MedicalReportsCache")
        } catch {
            print("Failed to save reports to UserDefaults: \(error)")
        }
    }
    
    // Helper to load reports from UserDefaults
    private func loadReportsFromUserDefaults() -> [MedicalReport] {
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
    
    // Helper to merge new reports with existing ones
    private func mergeAndUpdateReports(_ newReports: [MedicalReport]) {
        // Create a set of existing IDs for quick lookup
        let existingIds = Set(reports.map { $0.id })
        
        // Add any reports that don't already exist locally
        var updatedReports = reports
        for report in newReports {
            if !existingIds.contains(report.id) {
                updatedReports.append(report)
            }
        }
        
        // Sort by date
        updatedReports.sort { $0.date > $1.date }
        
        // Update reports and save to UserDefaults
        reports = updatedReports
        saveReportsToUserDefaults(updatedReports)
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
