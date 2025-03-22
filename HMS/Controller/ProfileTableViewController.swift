//
//  ProfileTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowChangePasswordTableViewController", let destination = segue.destination as? UINavigationController, let _ = destination.topViewController as? ChangePasswordTableViewController, let presentationController = segue.destination.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
    }

    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowChangePasswordTableViewController", sender: nil)
    }

}
