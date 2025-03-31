//
//  DashboardView.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct Specialization: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let name: String
    let image: String = "heart.fill"
}

struct DashboardView: View {
    weak var delegate: HomeHostingController?
    var specializations: [Specialization] = []

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
                        delegate?.performSegue(withIdentifier: "segueShowDoctorsHostingController", sender: specialization)
                    }
                )

                // My Appointments Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("My Appointments")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    ForEach(appointments) { appointment in
                        if appointment.startDate > Date() {
                            AppointmentCard(appointment: appointment)
                        }
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
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 130, height: 130)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
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
                .padding(.bottom, 8)
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

struct QuickActionsSection: View {

    // MARK: Internal

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
                    action: {
                        showingBookAppointment = true
                    }
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

    // MARK: Private

    @State private var showingBookAppointment = false
    @State private var showingMedicalRecords = false

}

struct BookAppointmentView: View {

    // MARK: Internal

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

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    @State private var selectedSpecialization: Specialization?
    @State private var selectedDate: Date = .init()

}
