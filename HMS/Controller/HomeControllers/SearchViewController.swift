import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}

    // MARK: Private

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Doctors"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Search"
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(searchBar)
        view.addSubview(resultsTableView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            resultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        resultsTableView.backgroundColor = .systemGroupedBackground

        searchBar.delegate = self
    }

}
