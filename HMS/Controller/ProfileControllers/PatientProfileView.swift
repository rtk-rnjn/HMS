//
//  PatientProfileView.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct PatientProfileView: View {
    var patient: Patient?
    weak var delegate: ProfileHostingController?

    var body: some View {

        Form {
            Section(header: Text("Personal Information")) {
                HStack {
                    Text("Full Name")
                    Spacer()
                    Text(patient?.fullName ?? "N/A")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text(patient?.emailAddress ?? "")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Date of Birth")
                    Spacer()
                    Text(patient?.dateOfBirth ?? Date(), style: .date)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Gender")
                    Spacer()
                    Text(patient?.gender.rawValue ?? "")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Blood Group")
                    Spacer()
                    Text(patient?.bloodGroup.rawValue ?? "")
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Health Information")) {
                HStack {
                    Text("Height")
                    Spacer()
                    Text("\(patient?.height ?? 0) cm")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Weight")
                    Spacer()
                    Text("\(patient?.weight ?? 0) kg")
                        .foregroundColor(.secondary)
                }
            }

            if let allergies = patient?.allergies, !allergies.isEmpty {
                Section(header: Text("Allergies")) {
                    ForEach(allergies, id: \..self) { allergy in
                        Text(allergy)
                    }
                }
            }

            if let medications = patient?.medications, !medications.isEmpty {
                Section(header: Text("Medications")) {
                    ForEach(medications, id: \..self) { medication in
                        Text(medication)
                    }
                }
            }

            if let disorders = patient?.disorders, !disorders.isEmpty {
                Section(header: Text("Disorders")) {
                    ForEach(disorders, id: \..self) { disorder in
                        Text(disorder)
                    }
                }
            }

            Section {
                Button("Change Password") {
                    // Action for changing password
                }
                Button("Logout") {
                    // Action for logout
                }
            }
        }
    }
}
