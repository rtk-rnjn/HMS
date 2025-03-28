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
                QuickActionButton(
                    icon: "folder.fill", title: "My Medical\nRecords",
                    color: .green,
                    action: { showingMedicalRecords = true }
                )
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingBookAppointment) {
            BookAppointmentView()
        }
        .sheet(isPresented: $showingMedicalRecords) {
            MedicalRecordsView()
        }
    }
}

struct MedicalRecordsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Recent Records")) {
                    MedicalRecordRow(title: "Blood Test Results", date: "Mar 15, 2024", type: "Lab Report")
                    MedicalRecordRow(title: "Annual Physical", date: "Feb 28, 2024", type: "Check-up Report")
                    MedicalRecordRow(title: "X-Ray Report", date: "Jan 10, 2024", type: "Radiology")
                }

                Section(header: Text("Prescriptions")) {
                    MedicalRecordRow(title: "Prescription #123", date: "Mar 10, 2024", type: "Medication")
                    MedicalRecordRow(title: "Prescription #122", date: "Feb 15, 2024", type: "Medication")
                }
            }
            .navigationTitle("Medical Records")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
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

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
            HStack {
                Text(date)
                Text("•")
                Text(type)
            }
            .font(.system(size: 14))
            .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
