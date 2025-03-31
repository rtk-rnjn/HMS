//
//  AddMedicalReportHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

class AddMedicalReportHostingController: UIHostingController<AddMedicalReportView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AddMedicalReportView())
    }
}
