//
//  DoctorSearchHostigController.swift
//  HMS
//
//  Created by RITIK RANJAN on 04/04/25.
//

import SwiftUI

class DoctorSearchHostigController: UIHostingController<DoctorListView>, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        Task {
            self.starStaff = await DataController.shared.fetchDoctor(bySymptom: searchText)
        }
    }

    var staffs: [Staff]? = []
    var starStaff: Staff?

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DoctorListView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSearchController()

        Task {
            staffs = await DataController.shared.fetchDoctors()
            DispatchQueue.main.async {
                self.rootView.filteredDoctors = self.staffs ?? []
            }
        }

        self.rootView.delegate = self
    }

    private var searchController: UISearchController = .init()

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Doctors"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
