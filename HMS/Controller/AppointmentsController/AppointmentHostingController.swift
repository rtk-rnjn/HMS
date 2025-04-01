//
//  AppointmentHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
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

    // MARK: Internal

    var searchController: UISearchController = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.appointments = sampleAppointments
        rootView.delegate = self

        prepareSearchController()

        Task {
            let appointments = await DataController.shared.fetchAppointments()
            self.rootView.appointments = appointments
        }
    }

    func updateSearchResults(for searchController: UISearchController) {}

    func showAppointmentDetails(_ appointment: Appointment) {
        let detailView = AppointmentDetailView(appointment: appointment, delegate: self)
        let detailVC = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - AppointmentDetailDelegate

    func refreshAppointments() {
        Task {
            let appointments = await DataController.shared.fetchAppointments()
            DispatchQueue.main.async {
                self.rootView.appointments = appointments
            }
        }
    }

    // MARK: Private

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Appointments"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}
