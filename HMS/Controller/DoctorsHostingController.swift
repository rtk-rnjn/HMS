//
//  DoctorsHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

class DoctorsHostingController: UIHostingController<DoctorListView> {

    // MARK: Lifecycle
    var specialization: String = ""

    required init?(coder: NSCoder) {
        let swiftUIView = DoctorListView()
        super.init(coder: coder, rootView: swiftUIView)
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            if let doctors = await DataController.shared.fetchDoctor(bySpecialization: specialization) {
                rootView.filteredDoctors = doctors
            }
        }
        rootView.delegate = self
    }

    func doctorsComplete() {
        performSegue(withIdentifier: "segueShowSignInViewController", sender: self)
    }
}
