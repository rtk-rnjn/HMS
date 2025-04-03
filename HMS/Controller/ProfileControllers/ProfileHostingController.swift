import SwiftUI
import UIKit

class ProfileHostingController: UIHostingController<ProfileDetailView> {

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ProfileDetailView(delegate: nil))
        self.rootView.delegate = self
        self.rootView.patient = DataController.shared.patient
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self

        if let patient = DataController.shared.patient {
            rootView.patient = patient
        }

        navigationItem.title = "Profile"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update patient data when view appears
        self.rootView.patient = DataController.shared.patient
    }

    func profileComplete() {
        performSegue(withIdentifier: "segueShowSignInViewController", sender: self)
    }

    func logout() {
        let cancel = AlertActionHandler(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }

        let logout = AlertActionHandler(title: "Logout", style: .destructive) { _ in
            DataController.shared.logout()
            self.performSegue(withIdentifier: "segueShowSignInViewController", sender: nil)
        }

        let alert = Utils.getAlert(title: "Logout", message: "Are you sure you want to logout?", actions: [logout, cancel])
        present(alert, animated: true)
    }
    
    func showChangePassword() {
        performSegue(withIdentifier: "segueShowChangePasswordTableViewController", sender: nil)
    }
}
