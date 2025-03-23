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
        prepareRefreshControl()

        navigationItem.title = DataController.shared.patient?.fullName
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareDoctors()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorTableViewCell", for: indexPath) as? DoctorTableViewCell
        guard let cell else { fatalError("mai pal do pal ka shayar hoon") }
        guard let doctors else { fatalError("pal do pal meri kahani hai") }
        cell.updateElements(with: doctors[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let doctor = doctors?[indexPath.row]
        performSegue(withIdentifier: "segueShowDoctorProfileTableViewController", sender: doctor)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowDoctorProfileTableViewController", let doctorProfileTableViewController = segue.destination as? DoctorProfileTableViewController, let doctor = sender as? Staff {
            doctorProfileTableViewController.doctor = doctor
        }
    }

    // MARK: Private

    private var searchController: UISearchController = .init()
    private var doctors: [Staff]? = []

    private func prepareDoctors() {
        Task {
            doctors = await DataController.shared.fetchDoctors()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private func prepareRefreshControl() {
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    @objc private func refresh() {
        refreshControl?.beginRefreshing()
        prepareDoctors()
        refreshControl?.endRefreshing()
    }

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
