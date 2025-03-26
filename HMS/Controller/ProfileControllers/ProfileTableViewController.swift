//
//  ProfileTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    // MARK: Internal

    @IBOutlet var dateOfBirthDatePicker: UIDatePicker!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var bloodTypeLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            let loggedIn = await DataController.shared.autoLogin()
            if loggedIn {
                DispatchQueue.main.async {
                    self.patient = DataController.shared.patient
                    self.navigationItem.title = self.patient?.fullName

                    self.prepareUI()
                }
            }
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowChangePasswordTableViewController", let destination = segue.destination as? UINavigationController, let _ = destination.topViewController as? ChangePasswordTableViewController, let presentationController = segue.destination.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
    }

    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowChangePasswordTableViewController", sender: nil)
    }

    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        let logoutAction = AlertActionHandler(title: "Logout", style: .destructive) { _ in
            DataController.shared.logout()
            self.performSegue(withIdentifier: "segueShowSignInViewController", sender: nil)
        }
        let cancelAction = AlertActionHandler(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let alert = Utils.getAlert(title: "Logout", message: "Are you sure you want to logout?", actions: [cancelAction, logoutAction])

        present(alert, animated: true, completion: nil)
    }

    // MARK: Private

    private var patient: Patient?

    private func prepareUI() {
        guard let patient else {
            return
        }

        dateOfBirthDatePicker.date = patient.dateOfBirth
        let age = Calendar.current.dateComponents([.year], from: patient.dateOfBirth, to: Date()).year ?? 0
        ageLabel.text = "\(age)"
        genderLabel.text = patient.gender.rawValue
        bloodTypeLabel.text = patient.bloodGroup.rawValue
        heightLabel.text = "\(patient.height)"
        weightLabel.text = "\(patient.weight)"
    }

}
