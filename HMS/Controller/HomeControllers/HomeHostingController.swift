//

//

//

import SwiftUI
import UIKit

class HomeHostingController: UIHostingController<DashboardView>, UISearchBarDelegate, UISearchResultsUpdating, DashboardViewDelegate {
    func customPerformSegue(withIdentifier id: String) {
        performSegue(withIdentifier: id, sender: nil)
    }
    

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

        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = "Home"
        rootView.delegate = self

        prepareSearchController()

        Task {
            await loadDepartments()
            await loadAppointments()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowDoctorsHostingController" {
            let destination = segue.destination as? DoctorsHostingController
            if let specialization = sender as? Department {
                destination?.department = specialization.name
            } else if let searchText = sender as? String {
                destination?.searchQuery = searchText
                destination?.isSearchMode = true
            }
        } else if segue.identifier == "segueShowAppointmentsViewController" {}
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {

        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
        return false
    }

    func updateSearchResults(for searchController: UISearchController) {}

    func showAppointmentDetails(_ appointment: Appointment) {

        if let tabBarController {
            tabBarController.selectedIndex = 1

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

    private func loadDepartments() async {
        if let staffs = await DataController.shared.fetchDoctors() {
            let departments = staffs.map { $0.department }
            let uniqueDepartments = Array(Set(departments)).sorted()
            DispatchQueue.main.async {
                self.rootView.departments = uniqueDepartments.map { department in
                    let image: String
                    switch department.lowercased() {
                        case let d where d.contains("dermatology"): image = "bandage"
                        case let d where d.contains("ent"): image = "ear"
                        case let d where d.contains("emergency"): image = "cross.case"
                        case let d where d.contains("endocrinology"): image = "pills"
                        case let d where d.contains("cardiology"): image = "heart"
                        case let d where d.contains("neurology"): image = "brain.head.profile"
                        case let d where d.contains("orthopedics"): image = "figure.walk"
                        case let d where d.contains("pediatrics"): image = "figure.2.and.child.holdinghands"
                        case let d where d.contains("psychiatry"): image = "brain"
                        case let d where d.contains("ophthalmology"): image = "eye"
                        case let d where d.contains("dentistry"): image = "mouth"
                        case let d where d.contains("surgery"): image = "cross.case.fill"
                        default: image = "stethoscope"
                    }
                    return Department(name: department, image: image)
                }
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
