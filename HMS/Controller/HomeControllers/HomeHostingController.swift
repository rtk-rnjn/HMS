//
//  HomeHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI
import UIKit

class HomeHostingController: UIHostingController<DashboardView>, UISearchBarDelegate, UISearchResultsUpdating, DashboardViewDelegate {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DashboardView())
    }

    // MARK: Internal

    var searchController: UISearchController = .init()

    var parentTabBarController: UITabBarController? {
        var parent: UIViewController? = self
        while parent != nil {
            if let tabBarController = parent as? UITabBarController {
                return tabBarController
            }
            parent = parent?.parent
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self

        // Set up the dashboard with specializations and appointments
        Task {
            await loadSpecializations()
            await loadAppointments()
        }
    }

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
        if segue.identifier == "segueShowDoctorsHostingController" {
            let destination = segue.destination as? DoctorsHostingController
            if let specialization = sender as? Specialization {
                destination?.specialization = specialization.name
            } else if let searchText = sender as? String {
                destination?.searchQuery = searchText
                destination?.isSearchMode = true
            }
        } else if segue.identifier == "segueShowAppointmentsViewController" {
            // No need to pass any data as the appointments view controller will fetch its own data
        }
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // Push the search view controller onto the navigation stack
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
        return false // Prevent the search bar from becoming first responder
    }

    func updateSearchResults(for searchController: UISearchController) {}

    // MARK: - DashboardViewDelegate

    func showAppointmentDetails(_ appointment: Appointment) {
        // Switch to the Appointments tab
        if let tabBarController {
            tabBarController.selectedIndex = 1 // Index of the Appointments tab

            // Notify the AppointmentHostingController to show the details
            NotificationCenter.default.post(
                name: NSNotification.Name("ShowAppointmentDetail"),
                object: appointment
            )
        }
    }

    // MARK: Private

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Doctors"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = false
        searchController.showsSearchResultsController = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func loadSpecializations() async {
        if let staffs = await DataController.shared.fetchDoctor(bySpecialization: "") {
            let specializations = staffs.map { $0.specialization }
            let uniqueSpecializations = Array(Set(specializations)).sorted()
            DispatchQueue.main.async {
                self.rootView.specializations = uniqueSpecializations.map { Specialization(name: $0) }
            }
        }
    }

    private func loadAppointments() async {
        let appointments = await DataController.shared.fetchAppointments()
        DispatchQueue.main.async {
            self.rootView.appointments = appointments
        }
    }
}
