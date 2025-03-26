//
//  InitialTabBarController.swift
//  HMS
//
//  Created by RITIK RANJAN on 21/03/25.
//

import UIKit

class InitialTabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: Internal

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate = self
        checkForAuthentication()

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: Private

    func checkForAuthentication() {
        guard DataController.shared.patient == nil else { return }

        Task {
            let success = await DataController.shared.autoLogin()
            guard !success else { return }
            DispatchQueue.main.async {
                let action = AlertActionHandler(title: "OK", style: .default) { _ in
                    DataController.shared.logout()
                    self.performSegue(withIdentifier: "segueShowSignInViewController", sender: self)
                }
                let alert = Utils.getAlert(title: "Error", message: "Authentication Failed. Please login again.", actions: [action])
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
