//
//  OnBoardingHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 21/03/25.
//

import SwiftUI

class OnBoardingHostingController: UIHostingController<OnboardingView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: OnboardingView())
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
    }

    func onboardingComplete() {
        performSegue(withIdentifier: "segueShowSignInViewController", sender: self)
    }
}
