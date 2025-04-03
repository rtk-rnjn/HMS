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

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredDoctors, id: \.id) { doctor in
                        DoctorCard(doctor: doctor)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical, 12)
            }
        }
    }

    // MARK: Private

    @State private var searchText = ""
    @State private var showingAddDoctorView = false
}
