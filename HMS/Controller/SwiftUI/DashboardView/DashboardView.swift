//
//  DashboardView.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct Specialization: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let image: String
}

let specializations = [
    Specialization(name: "Cardiologist", image: "heart.fill"),
    Specialization(name: "Neurologist", image: "brain.head.profile"),
    Specialization(name: "Orthopedic Surgeon", image: "figure.walk"),
    Specialization(name: "Pediatrician", image: "person.2.circle"),
    Specialization(name: "Gynecologist/Obstetrician", image: "person.2.wave.2.fill"),
    Specialization(name: "Oncologist", image: "cross.case.fill"),
    Specialization(name: "Radiologist", image: "rays"),
    Specialization(name: "Emergency Medicine", image: "cross.circle.fill"),
    Specialization(name: "Dermatologist", image: "hand.raised.fill"),
    Specialization(name: "Psychiatrist", image: "brain.fill"),
    Specialization(name: "Gastroenterologist", image: "pills.fill"),
    Specialization(name: "Nephrologist", image: "cross.vial.fill"),
    Specialization(name: "Endocrinologist", image: "chart.dots.scatter"),
    Specialization(name: "Pulmonologist", image: "lungs.fill"),
    Specialization(name: "Ophthalmologist", image: "eye.fill"),
    Specialization(name: "ENT Specialist", image: "ear.fill"),
    Specialization(name: "Urologist", image: "cross.fill"),
    Specialization(name: "Anesthesiologist", image: "waveform.path.ecg"),
    Specialization(name: "Hematologist", image: "drop.fill"),
    Specialization(name: "Rheumatologist", image: "figure.walk.motion")
]

struct DashboardView: View {
    weak var delegate: HomeHostingController?

    @State private var searchText = ""
    @State private var selectedSpecialization: Specialization?

    var appointments: [Appointment] = []

    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Specializations Section
                SpecializationsSection(
                    specializations: specializations,
                    onTap: { specialization in
                        selectedSpecialization = specialization
                    }
                )

                // My Appointments Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("My Appointments")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    ForEach(appointments) { appointment in
                        AppointmentCard(date: "", time: "", doctorName: "", specialty: "", hospital: "", status: "")
                    }
                    .padding(.horizontal)
                }

                // Quick Actions Section
                QuickActionsSection()
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer,
            prompt: "Search doctors or specializations"
        )
        .navigationDestination(item: $selectedSpecialization) { specialization in
            SpecializationDetailView(specialization: specialization)
        }
    }
}

struct SpecializationCard: View {
    let specialization: Specialization

    var body: some View {
        VStack(spacing: 16) {
            // Icon
            Image(systemName: specialization.image)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color(red: 0.27, green: 0.53, blue: 1.0))
                .clipShape(Circle())

            // Title
            Text(specialization.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 150, height: 150)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 2)
    }
}

struct SpecializationsSection: View {
    let specializations: [Specialization]
    let onTap: (Specialization) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Specializations")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(specializations) { specialization in
                        SpecializationCard(specialization: specialization)
                            .onTapGesture {
                                onTap(specialization)
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8) // Add padding to account for shadow
            }
        }
    }
}

struct SpecializationDetailView: View {
    let specialization: Specialization
    @State private var searchText = ""
    var staff: [Staff] = []

    var body: some View {
        List(staff) { doctor in
            DoctorCard(doctor: doctor)
        }
        .listStyle(PlainListStyle())
        .background(Color(.systemGroupedBackground))
        .navigationTitle(specialization.name)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer,
            prompt: "Search doctors"
        )
    }
}

struct DoctorCard: View {
    let doctor: Staff

    var body: some View {
        NavigationLink(destination: DoctorView(doctor: doctor)) {
            HStack(spacing: 12) {
                // Profile image
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(.systemGray3))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    // Name
                    Text(doctor.fullName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)

                    // Department and specialization
                    Text(doctor.department)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)

                    Text(doctor.specializations.joined(separator: ", "))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Status indicator - small dot instead of badge for cleaner list
                Circle()
                    .fill(doctor.onLeave ? Color.orange : Color.green)
                    .frame(width: 10, height: 10)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
        }
    }
}

struct QuickActionsSection: View {
    @State private var showingBookAppointment = false
    @State private var showingMedicalRecords = false
    @State private var navigateToMedicalRecords = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                QuickActionButton(
                    icon: "calendar.badge.plus",
                    title: "Book New\nAppointment",
                    color: .blue,
                    action: { showingBookAppointment = true }
                )
                NavigationLink(destination: MedicalRecordsView()) {
                    QuickActionButtonView(
                        icon: "folder.fill",
                        title: "My Medical\nRecords",
                        color: .green
                    )
                }
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingBookAppointment) {
            BookAppointmentView()
        }
    }
}

struct QuickActionButtonView: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 2)
    }
}

struct MedicalRecordsView: View {
    @State private var showingAddReport = false
    @State private var reports: [MedicalReport] = []
    @State private var showingFilterSheet = false
    @State private var selectedFilter: String? = nil
    
    private func loadReports() {
        reports = DataController.shared.getMedicalReports().sorted(by: { $0.createdAt > $1.createdAt })
    }
    
    private var filteredReports: [MedicalReport] {
        if let filter = selectedFilter {
            return reports.filter { $0.reportType == filter }
        }
        return reports
    }
    
    private var uniqueReportTypes: [String] {
        Array(Set(reports.map { $0.reportType })).sorted()
    }
    
    var body: some View {
        List {
            if !reports.isEmpty {
                ForEach(filteredReports) { report in
                    MedicalRecordRow(
                        title: report.description.isEmpty ? report.reportType : report.description,
                        date: report.reportDate.formatted(date: .numeric, time: .omitted),
                        type: report.reportType,
                        report: report
                    )
                    .listRowBackground(Color(.systemGroupedBackground))
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
            } else {
                Text("No medical records yet")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .listRowBackground(Color(.systemGroupedBackground))
            }
        }
        .listStyle(PlainListStyle())
        .background(Color(.systemGroupedBackground))
        .scrollContentBackground(.hidden)
        .navigationTitle("Medical Records")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: {
                        showingFilterSheet = true
                    }) {
                        Image(systemName: selectedFilter == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        showingAddReport = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddReport) {
            AddMedicalReportView(onSave: { _ in
                loadReports()
            })
        }
        .confirmationDialog("Filter by Type", isPresented: $showingFilterSheet, titleVisibility: .visible) {
            ForEach(uniqueReportTypes, id: \.self) { type in
                Button(type) {
                    selectedFilter = type
                }
            }
            if selectedFilter != nil {
                Button("Show All", role: .cancel) {
                    selectedFilter = nil
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .onAppear {
            loadReports()
        }
    }
}

struct BookAppointmentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSpecialization: Specialization?
    @State private var selectedDate = Date()

    var body: some View {

        ScrollView {
            VStack(spacing: 20) {
                // Date Selection
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)

                // Specializations
                SpecializationsSection(
                    specializations: specializations,
                    onTap: { specialization in
                        selectedSpecialization = specialization
                    }
                )
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Book Appointment")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
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
    }
}
