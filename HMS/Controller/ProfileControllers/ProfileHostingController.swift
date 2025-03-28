//
//  ProfileHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

class ProfileHostingController: UIHostingController<PatientProfileView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: PatientProfileView(patient: DataController.shared.patient))
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self

        if let patient = DataController.shared.patient {
            rootView.patient = patient
        }

        navigationItem.title = "Profile"
    }

    func profileComplete() {
        performSegue(withIdentifier: "segueShowSignInViewController", sender: self)
    }
}
