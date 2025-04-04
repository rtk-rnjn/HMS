//

//

//

import SwiftUI

protocol DashboardViewDelegate: AnyObject {
    func showAppointmentDetails(_ appointment: Appointment)
    func customPerformSegue(withIdentifier: String)
}

struct Department: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let name: String
    let image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

struct DashboardView: View {
    weak var delegate: DashboardViewDelegate?
    var departments: [Department] = [
        Department(name: "Dermatology", image: "bandage"),
        Department(name: "ENT (Ear, Nose & Throat)", image: "ear"),
        Department(name: "Emergency & Trauma", image: "cross.case"),
        Department(name: "Endocrinology", image: "pills"),
        Department(name: "Cardiology", image: "heart"),
        Department(name: "Neurology", image: "brain.head.profile"),
        Department(name: "Orthopedics", image: "figure.walk"),
        Department(name: "Pediatrics", image: "figure.2.and.child.holdinghands"),
        Department(name: "Psychiatry", image: "brain"),
        Department(name: "Ophthalmology", image: "eye"),
        Department(name: "Dentistry", image: "mouth"),
        Department(name: "General Surgery", image: "cross.case.fill")
    ]

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
                            .foregroundColor(.primary)
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
                                .font(.largeTitle)
                                .foregroundColor(Color("iconBlue"))
                            Text("No Appointments Today")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Check the Appointments tab for upcoming visits")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(Color(.secondarySystemGroupedBackground))
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

                QuickActionsSection(delegate: delegate)
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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color("iconBlue"))
                .frame(width: 52, height: 52)
                .overlay(
                    Image(systemName: department.image)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                )

            Text(department.name)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(height: 40)
                .padding(.horizontal, 8)
        }
        .frame(width: 120, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color(.separator), lineWidth: 0.5)
                )
        )
    }
}

struct SpecializationsSection: View {
    let departments: [Department]
    let onTap: (Department) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Departments")
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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(staff) { doctor in
                    DoctorCard(doctor: doctor)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical, 12)
        }
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
    @Environment(\.colorScheme) var colorScheme
    @State private var showingBookAppointment = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Circle()
                    .fill(Color("iconBlue"))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(doctor.fullName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(doctor.department)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    
                    Text(doctor.specialization)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Circle()
                        .fill(doctor.onLeave ? Color.orange : Color.green)
                        .frame(width: 10, height: 10)
                    
                    if doctor.onLeave {
                        Text("On Leave")
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            
            Divider()
                .padding(.horizontal, 16)
            
            HStack(spacing: 24) {
                
                NavigationLink(destination: DoctorView(doctor: doctor)) {
                    HStack {
                        Image(systemName: "person.text.rectangle")
                        Text("View Profile")
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("iconBlue"))
                }
            }
            .padding(.vertical, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color(.separator), lineWidth: 0.5)
                )
        )
        .sheet(isPresented: $showingBookAppointment) {
            NavigationView {
                BookAppointmentView()
            }
        }
    }
}

struct QuickActionsSection: View {
    weak var delegate: DashboardViewDelegate?
    @Environment(\.colorScheme) var colorScheme
    @State private var showingEmergencyAlert = false
    private let emergencyNumbers = [
        ("Ambulance", "102"),
        ("Medical Emergency", "108")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                QuickActionButton(
                    icon: "creditcard.fill",
                    title: "Billing",
                    subtitle: "View & pay bills",
                    color: Color("iconBlue"),
                    action: {
                        delegate?.customPerformSegue(withIdentifier: "segueShowBillingHostingController")
                    }
                )
                QuickActionButton(
                    icon: "cross.case.fill",
                    title: "Emergency",
                    subtitle: "Get immediate help",
                    color: Color("iconBlue"),
                    action: {
                        showingEmergencyAlert = true
                    }
                )
            }
            .padding(.horizontal)
        }
        .alert("Emergency Services", isPresented: $showingEmergencyAlert) {
            ForEach(emergencyNumbers, id: \.0) { name, number in
                Button("\(name) (\(number))", role: .destructive) {
                    if let url = URL(string: "tel://\(number)") {
                        UIApplication.shared.open(url)
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Select emergency service to call")
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color(.separator), lineWidth: 0.5)
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
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

// MARK: - Previews
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DashboardView(
                departments: sampleDepartments,
                appointments: sampleAppointments
            )
        }
        .preferredColorScheme(.light)
        
        NavigationView {
            DashboardView(
                departments: sampleDepartments,
                appointments: sampleAppointments
            )
        }
        .preferredColorScheme(.dark)
    }
    
    // Sample Data
    static var sampleDepartments: [Department] = [
        Department(name: "Dermatology", image: "bandage"),
        Department(name: "ENT (Ear, Nose & Throat)", image: "ear"),
        Department(name: "Emergency & Trauma", image: "cross.case"),
        Department(name: "Cardiology", image: "heart")
    ]
    
    static var sampleAppointments: [Appointment] = {
        let calendar = Calendar.current
        let today = Date()
        
        let doctor1 = Staff(
            firstName: "John",
            lastName: "Smith",
            emailAddress: "john.smith@hospital.com",
            dateOfBirth: calendar.date(byAdding: .year, value: -35, to: today) ?? today,
            password: "password123",
            contactNumber: "+1234567890",
            specialization: "Heart Specialist",
            department: "Cardiology",
            onLeave: false,
            licenseId: "LIC123456"
        )
        
        let doctor2 = Staff(
            firstName: "Sarah",
            lastName: "Johnson",
            emailAddress: "sarah.johnson@hospital.com",
            dateOfBirth: calendar.date(byAdding: .year, value: -30, to: today) ?? today,
            password: "password123",
            contactNumber: "+1234567891",
            specialization: "Skin Specialist",
            department: "Dermatology",
            onLeave: true,
            licenseId: "LIC123457"
        )

        let appointment1 = Appointment(
            id: "1",
            patientId: "p1",
            doctorId: "d1",
            doctor: doctor1,
            startDate: calendar.date(byAdding: .hour, value: 2, to: today) ?? today,
            endDate: calendar.date(byAdding: .hour, value: 3, to: today) ?? today,
            status: .confirmed
        )
        
        let appointment2 = Appointment(
            id: "2",
            patientId: "p1",
            doctorId: "d2",
            doctor: doctor2,
            startDate: calendar.date(byAdding: .hour, value: 4, to: today) ?? today,
            endDate: calendar.date(byAdding: .hour, value: 5, to: today) ?? today,
            status: .confirmed
        )
        
        return [appointment1, appointment2]
    }()
}

struct DoctorCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DoctorCard(doctor: sampleDoctor)
                .padding()
            
            DoctorCard(doctor: sampleDoctorOnLeave)
                .padding()
        }
        .background(Color(.systemGroupedBackground))
        .previewLayout(.sizeThatFits)
        
        VStack {
            DoctorCard(doctor: sampleDoctor)
                .padding()
            
            DoctorCard(doctor: sampleDoctorOnLeave)
                .padding()
        }
        .background(Color(.systemGroupedBackground))
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
    static var sampleDoctor: Staff = {
        let calendar = Calendar.current
        let today = Date()
        
        return Staff(
            firstName: "Rajesh",
            lastName: "Kumar",
            emailAddress: "dr.rajesh.kumar@hospital.com",
            dateOfBirth: calendar.date(byAdding: .year, value: -35, to: today) ?? today,
            password: "password123",
            contactNumber: "+919876543210",
            specialization: "Heart Specialist",
            department: "Cardiology",
            onLeave: false,
            licenseId: "MCI123456"
        )
    }()
    
    static var sampleDoctorOnLeave: Staff = {
        let calendar = Calendar.current
        let today = Date()
        
        return Staff(
            firstName: "Priya",
            lastName: "Sharma",
            emailAddress: "dr.priya.sharma@hospital.com",
            dateOfBirth: calendar.date(byAdding: .year, value: -30, to: today) ?? today,
            password: "password123",
            contactNumber: "+919876543211",
            specialization: "Skin Specialist",
            department: "Dermatology",
            onLeave: true,
            licenseId: "MCI123457"
        )
    }()
}

struct QuickActionsSection_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            QuickActionsSection()
                .padding()
        }
        .background(Color(.systemGroupedBackground))
        .previewLayout(.sizeThatFits)
        
        VStack {
            QuickActionsSection()
                .padding()
        }
        .background(Color(.systemGroupedBackground))
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
