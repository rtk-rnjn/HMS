//
//  InitialTabBarController.swift
//  HMS
//
//  Created by RITIK RANJAN on 21/03/25.
//

import UIKit

class InitialTabBarController: UITabBarController {

    // MARK: Internal

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)

        checkForAuthentication()
    }

    // MARK: Private

    private func checkForAuthentication() {
        if DataController.shared.patient == nil {
            Task {
                let success = await DataController.shared.autoLogin()
                if !success {
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
    }
}
