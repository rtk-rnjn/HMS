import SwiftUI

class DoctorSearchHostigController: UIHostingController<DoctorListView>, UISearchResultsUpdating, UISearchBarDelegate {
    private var searchWorkItem: DispatchWorkItem?

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""

        guard let staffs else {
            return
        }

        searchWorkItem?.cancel() // Cancel previous work item if any

        let workItem = DispatchWorkItem {
            DispatchQueue.main.async {
                if searchText.isEmpty {
                    self.rootView.filteredDoctors = staffs
                } else {
                    self.rootView.filteredDoctors = staffs.filter {
                        $0.fullName.lowercased().contains(searchText.lowercased()) ||
                        $0.department.lowercased().contains(searchText.lowercased()) ||
                        $0.specialization.lowercased().contains(searchText.lowercased())
                    }
                }
            }
        }

        searchWorkItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: workItem) // Debounce delay of 300ms
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
