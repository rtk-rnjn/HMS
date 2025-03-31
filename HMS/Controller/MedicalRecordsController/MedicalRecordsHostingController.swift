//
//  MedicalRecordsHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

class MedicalRecordsHostingController: UIHostingController<MedicalRecordsView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: MedicalRecordsView())
    }

}
