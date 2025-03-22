//
//  HomeTableViewController.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit

class HomeTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSearchController()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorTableViewCell", for: indexPath) as? DoctorTableViewCell
        guard let cell else { fatalError("mai pal do pal ka shayar hoon") }
        cell.updateElements(with: doctors[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let doctor = doctors[indexPath.row]
        performSegue(withIdentifier: "segueShowDoctorProfileTableViewController", sender: doctor)
    }

    // MARK: Private

    private var searchController: UISearchController = .init()
    private var doctors: [Staff] = []
}

extension HomeTableViewController {
    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Doctors"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func updateSearchResults(for searchController: UISearchController) {}

}
