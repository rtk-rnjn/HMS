//

//

//

import SwiftUI

class MedicalRecordsHostingController: UIHostingController<MedicalRecordsView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: MedicalRecordsView())
    }

    // MARK: Internal

    var reports: [MedicalReport] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadReports()
    }

    func loadReports() {
        Task {
            reports = await DataController.shared.fetchMedicalReports()
            DispatchQueue.main.async {
                self.rootView.reports = self.reports
            }
        }
    }
}
