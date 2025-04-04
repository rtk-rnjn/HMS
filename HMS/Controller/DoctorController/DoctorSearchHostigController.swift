import SwiftUI

class DoctorSearchHostigController: UIHostingController<DoctorListView>, UISearchResultsUpdating, UISearchBarDelegate {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DoctorListView())
    }

    // MARK: Internal

    var staffs: [Staff]? = []
    var starStaff: Staff?

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSearchController()

        Task {
            staffs = await DataController.shared.fetchDoctors()
            starStaff = await DataController.shared.fetchDoctor(bySymptom: "") // Fetch based on symptoms
            DispatchQueue.main.async {
                if let starStaff = self.starStaff {
                    self.rootView.filteredDoctors = [starStaff] + (self.staffs?.filter { $0.id != starStaff.id } ?? [])
                } else {
                    self.rootView.filteredDoctors = self.staffs ?? []
                }
            }
        }

        rootView.delegate = self
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""

        guard let staffs else {
            return
        }

        searchWorkItem?.cancel() // Cancel previous work item if any

        let workItem = DispatchWorkItem {
            Task {
                let updatedStarStaff = await DataController.shared.fetchDoctor(bySymptom: searchText)

                DispatchQueue.main.async {
                    var filteredResults: [Staff] = []

                    if searchText.isEmpty {
                        filteredResults = staffs
                    } else {
                        filteredResults = staffs.filter {
                            $0.fullName.lowercased().contains(searchText.lowercased()) ||
                            $0.department.lowercased().contains(searchText.lowercased()) ||
                            $0.specialization.lowercased().contains(searchText.lowercased())
                        }
                    }

                    if let updatedStarStaff, !filteredResults.contains(where: { $0.id == updatedStarStaff.id }) {
                        self.rootView.filteredDoctors = [updatedStarStaff] + filteredResults
                    } else {
                        self.rootView.filteredDoctors = filteredResults
                    }
                }
            }
        }

        searchWorkItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: workItem) // Debounce delay of 300ms
    }

    // MARK: Private

    private var searchWorkItem: DispatchWorkItem?

    private var searchController: UISearchController = .init()

    private func prepareSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Doctors"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
