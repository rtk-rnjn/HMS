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
}
