//

//

//

import SwiftUI

struct DoctorListView: View {

    // MARK: Internal

    var delegate: DoctorsHostingController?
    var filteredDoctors: [Staff] = []

    var body: some View {

        ZStack {

            Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(filteredDoctors, id: \.id) { doctor in
                            DoctorCard(doctor: doctor)
                        }

                        Color.clear.frame(height: 20)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    // MARK: Private

    @State private var searchText = ""
    @State private var showingAddDoctorView = false
}

struct DoctorCard: View {
    let doctor: Staff

    var body: some View {
        NavigationLink(destination: DoctorView(doctor: doctor)) {
            HStack(spacing: 12) {

                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("iconBlue"))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )

                VStack(alignment: .leading, spacing: 4) {

                    Text(doctor.fullName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)

                    Text(doctor.department)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)

                    Text(doctor.specialization)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                }

                Spacer()

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
