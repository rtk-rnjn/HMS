//
//  ViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 18/03/25.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let patientOnboardingWalkthroughSwiftUI = PatientOnboardingWalkthroughView()
        let hostingController = UIHostingController(rootView: patientOnboardingWalkthroughSwiftUI)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
