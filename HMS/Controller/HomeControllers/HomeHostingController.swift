//
//  HomeHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

class HomeHostingController: UIHostingController<DashboardView>, UISearchBarDelegate, UISearchResultsUpdating {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DashboardView())
    }

    // MARK: Internal

    var searchController: UISearchController = .init()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Home"
        
        rootView.delegate = self

        Task {
            if let staffs = await DataController.shared.fetchDoctor(bySpecialization: "") {
                let specializations = staffs.map { $0.specialization }
                rootView.specializations = specializations.map { Specialization(name: $0) }
            }
        }
        prepareSearchController()

        Task {
            let appointments = await DataController.shared.fetchAppointments()
            self.rootView.appointments = appointments
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowDoctorsHostingController", let specialization = sender as? Specialization {
            let destination = segue.destination as? DoctorsHostingController
            destination?.specialization = specialization.name
        } else if segue.identifier == "segueShowAppointmentsViewController" {
            // No need to pass any data as the appointments view controller will fetch its own data
        }
    }

    func updateSearchResults(for searchController: UISearchController) {}

    // MARK: Private

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Doctors"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
