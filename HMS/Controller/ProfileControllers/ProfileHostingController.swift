//

//

//

import SwiftUI

class ProfileHostingController: UIHostingController<ProfileDetailView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        let patient = DataController.shared.patient
        super.init(coder: coder, rootView: ProfileDetailView(patient: patient))
        rootView.delegate = self
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update patient data when view appears
        rootView.patient = DataController.shared.patient
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
}
