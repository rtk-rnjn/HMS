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

        navigationItem.title = "Hello, \((DataController.shared.patient?.firstName ?? "User") as String)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareDoctors()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? max(filteredDoctors.count, 1) : (doctors?.count ?? 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching && filteredDoctors.isEmpty {
             let cell = UITableViewCell(style: .default, reuseIdentifier: "NoDoctorCell")
             cell.textLabel?.text = "No doctor found"
             cell.textLabel?.textAlignment = .center
             cell.textLabel?.textColor = .gray
             return cell
         }

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

    private var filteredDoctors: [Staff] = []

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

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased(), !query.isEmpty else {
                      filteredDoctors = doctors ?? []
                      tableView.reloadData()
                      return
                  }

                  filteredDoctors = doctors?.filter { doctor in
                      doctor.firstName.lowercased().contains(query) ||
                      doctor.specializations.contains { $0.lowercased().contains(query) }
                  } ?? []

                  tableView.reloadData()
    }

    private var isSearching: Bool {
          return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
      }

}
