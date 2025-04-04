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

    var appointments: [Appointment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.delegate = self
        navigationItem.title = "My Appointments"
        navigationItem.largeTitleDisplayMode = .automatic
           navigationController?.navigationBar.prefersLargeTitles = true

        prepareSearchController()
        loadAppointments()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShowAppointmentDetail(_:)),
            name: NSNotification.Name("ShowAppointmentDetail"),
            object: nil
        )
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }

        if searchText.isEmpty || searchText == "" {
            rootView.appointments = appointments
            return
        }

        rootView.appointments = appointments.filter {
            $0.doctor?.fullName.lowercased().contains(searchText.lowercased()) ?? true
        }
    }

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
            appointments = await DataController.shared.fetchAppointments()
            DispatchQueue.main.async {
                self.rootView.appointments = self.appointments
            }
        }
    }

    private func prepareSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Appointments"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}
