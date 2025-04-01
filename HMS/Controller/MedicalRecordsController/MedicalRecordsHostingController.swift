//
//  MedicalRecordsHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

class MedicalRecordsHostingController: UIHostingController<MedicalRecordsView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: MedicalRecordsView())
    }

    // MARK: Internal

    var reports: [MedicalReport] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
    }

}
