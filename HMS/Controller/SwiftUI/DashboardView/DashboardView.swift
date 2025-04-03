//

//

//

import SwiftUI

protocol DashboardViewDelegate: AnyObject {
    func showAppointmentDetails(_ appointment: Appointment)
}

struct Department: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let name: String
    let image: String = "heart.fill"
}

struct DashboardView: View {
    weak var delegate: DashboardViewDelegate?
    var departments: [Department] = []

    @State private var searchText = ""
    @State private var selectedDepartment: Department?

    var appointments: [Appointment] = []

    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                SpecializationsSection(
                    departments: departments,
                    onTap: { department in
                        if let homeController = delegate as? HomeHostingController {
                            homeController.performSegue(withIdentifier: "segueShowDoctorsHostingController", sender: department)
                        }
                    }
                )

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Today's Appointments")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.horizontal, 16)

                    let todayAppointments = appointments
                        .filter {
                            let calendar = Calendar.current
                            return calendar.isDate($0.startDate, inSameDayAs: Date())
                        }
                        .sorted { $0.startDate < $1.startDate }
                        .prefix(3)

                    if todayAppointments.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.system(size: 40))
                                .foregroundColor(Color("iconBlue"))
                            Text("No Appointments Today")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Check the Appointments tab for upcoming visits")
                                .font(.subheadline)
                                .foregroundColor(.gray.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    } else {
                        LazyVStack(spacing: 4) {
                            ForEach(Array(todayAppointments)) { appointment in
                                AppointmentCard(appointment: appointment)
                                    .onTapGesture {
                                        delegate?.showAppointmentDetails(appointment)
                                    }
                            }
                        }
                        .padding(.horizontal, 0)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    }
                }

                QuickActionsSection()
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer,
            prompt: "Search doctors or departments"
        )
    }
}

struct DepartmentCard: View {
    let department: Department

    var body: some View {
        VStack {
            Spacer()

            Circle()
                .fill(Color("iconBlue"))
                .frame(width: 46, height: 46)
                .overlay(
                    Image(systemName: department.image)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                )

            Spacer()

            Text(department.name)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 32)
                .padding(.horizontal, 4)
                .padding(.bottom, 8)
        }
        .frame(width: 105, height: 105)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
    }
}

struct SpecializationsSection: View {
    let departments: [Department]
    let onTap: (Department) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Specializations")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(departments) { department in
                        DepartmentCard(department: department)
                            .onTapGesture {
                                onTap(department)
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
    let specialization: Department
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
                .fontWeight(.semibold)
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
                    color: .unselectedBlue,
                    action: {
                        showingBookAppointment = true
                    }
                )
                QuickActionButton(
                    icon: "folder.fill", title: "Add Medical\nRecords",
                    color: .unselectedBlue,
                    action: { showingMedicalRecords = true }
                )
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingBookAppointment) {
            BookAppointmentView()
        }
        .sheet(isPresented: $showingMedicalRecords) {
            AddMedicalReportView()
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
                Button(action: {
                    navigateToSearch()
                }) {
                    Text("Next")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canProceed ? Color.blue : Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!canProceed)
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

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    @State private var selectedSpecialization: Department?
    @State private var selectedDate: Date = .init()

    private var canProceed: Bool {
       selectedDate != nil
    }

   private func navigateToSearch() {
       if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = windowScene.windows.first?.rootViewController {

           let searchController = UISearchController()
           searchController.obscuresBackgroundDuringPresentation = false
           searchController.searchBar.placeholder = "Search doctors or departments"

           rootViewController.present(searchController, animated: true, completion: nil)
       }
   }
}
