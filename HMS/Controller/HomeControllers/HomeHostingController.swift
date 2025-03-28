//
//  HomeHostingController.swift
//  HMS
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

class HomeHostingController: UIHostingController<DashboardView>, UISearchBarDelegate, UISearchResultsUpdating {
    

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DashboardView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self

        Task {
            if let staffs = await DataController.shared.fetchDoctor(bySpecialization: "") {
                let specializations = staffs.map { $0.specialization }
                rootView.specializations = specializations.map { Specialization(name: $0) }
            }
        }
        prepareSearchController()
    }

    var searchController: UISearchController = .init()

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Doctors"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func updateSearchResults(for searchController: UISearchController) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowDoctorsHostingController", let specialization = sender as? Specialization {
            let destination = segue.destination as? DoctorsHostingController
            destination?.specialization = specialization.name
        }
    }
}
