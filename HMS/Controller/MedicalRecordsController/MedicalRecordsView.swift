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

                        Image(systemName: getIconName(for: type))
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }

                    VStack(alignment: .leading, spacing: 12) {

                        HStack(alignment: .center) {
                            Text(type)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(1)

                            Spacer()

                            Text(date)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }

                        if !title.isEmpty {
                            Text(title)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
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

                        if let status = report.status {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(getStatusColor(status))
                                    .frame(width: 8, height: 8)
                                Text(status)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(getStatusColor(status))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(getStatusColor(status).opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(Color.white)
            .cornerRadius(16)
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

    private func getStatusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "completed":
            return .green
        case "pending":
            return .orange
        case "in progress":
            return .blue
        case "cancelled":
            return .red
        default:
            return .gray
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
                .foregroundColor(.red)
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
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                            TextField("Search medical records", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.system(size: 16))
                            if !searchText.isEmpty {
                                Button(action: {
                                    withAnimation {
                                        searchText = ""
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(12)

                        Button(action: {
                            showingFilterSheet = true
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 24))
                                .foregroundColor(hasActiveFilters ? .blue : .gray)
                                .overlay(
                                    Group {
                                        if !activeFiltersCount.isEmpty {
                                            Text(activeFiltersCount)
                                                .font(.system(size: 12, weight: .bold))
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
                .background(Color.white)

                if filteredReports.isEmpty {

                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 100, height: 100)
                            )

                        VStack(spacing: 8) {
                            Text("No Records Found")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)

                            Text("Try adjusting your search or filters")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
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
                    .background(Color(.systemGroupedBackground))
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
        .refreshable {
            await loadReports()
        }
    }

    // MARK: Private

    @State private var reports: [MedicalReport] = []
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
        let fetchedReports = await DataController.shared.fetchMedicalReports()
        withAnimation {
            reports = fetchedReports
        }
    }

}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.white)
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
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
                .font(.system(size: 13))
                .foregroundColor(.gray)

            Button(action: {
                showingDatePicker.toggle()
            }) {
                HStack {
                    Text(date.formatted(.dateTime.day().month().year()))
                        .font(.system(size: 15))
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
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
                .foregroundColor(.red)

                Button("Done") {
                    onDateSelected(tempDate)
                }
                .fontWeight(.medium)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    @State private var tempDate: Date

}
