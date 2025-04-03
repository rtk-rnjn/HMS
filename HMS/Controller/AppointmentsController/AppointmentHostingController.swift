//

//

//

import SwiftUI

let calendar: Calendar = .current
let currentDate: Date = .init()

let sampleAppointments: [Appointment] = []

class AppointmentHostingController: UIHostingController<AppointmentView>, UISearchBarDelegate, UISearchResultsUpdating, AppointmentDetailDelegate {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AppointmentView())
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Internal

    var searchController: UISearchController = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.delegate = self
        navigationItem.title = "My Appointments"

        prepareSearchController()
        loadAppointments()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShowAppointmentDetail(_:)),
            name: NSNotification.Name("ShowAppointmentDetail"),
            object: nil
        )
    }

    func updateSearchResults(for searchController: UISearchController) {}

    func showAppointmentDetails(_ appointment: Appointment) {
        let detailView = AppointmentDetailView(appointment: appointment, delegate: self)
        let detailVC = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func refreshAppointments() {
        loadAppointments()
    }

    // MARK: Private

    @objc private func handleShowAppointmentDetail(_ notification: Notification) {
        if let appointment = notification.object as? Appointment {
            showAppointmentDetails(appointment)
        }
    }

    private func loadAppointments() {
        Task {
            let appointments = await DataController.shared.fetchAppointments()
            DispatchQueue.main.async {
            self.rootView.appointments = appointments
            }
        }
    }

    private func prepareSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Appointments"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}
