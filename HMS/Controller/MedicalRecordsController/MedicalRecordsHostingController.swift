//

//

//

import SwiftUI
import UIKit

class MedicalRecordsHostingController: UIHostingController<MedicalRecordsView> {

    // MARK: Lifecycle
    private var isRefreshing = false
    private var lastRefreshTime: Date?

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: MedicalRecordsView())
    }

    // MARK: Internal

    var reports: [MedicalReport] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        
        // Add notification observer for medical report added
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMedicalReportAdded),
            name: NSNotification.Name("MedicalReportAdded"),
            object: nil
        )
        
        // Add tab bar selection observer
        NotificationCenter.default.addObserver(
            self, 
            selector: #selector(handleTabBarSelection), 
            name: NSNotification.Name("TabBarSelectionChanged"), 
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Only refresh if enough time has passed since last refresh
        if shouldRefresh() {
            // Refresh reports when view appears
            loadReports()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Post a notification to setup tab selection tracking
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("SetupTabBarObserver"), object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check if destination is AddMedicalReportHostingController
        if let addReportController = segue.destination as? AddMedicalReportHostingController {
            addReportController.delegate = self
        } 
        // Check if destination is UINavigationController with AddMedicalReportHostingController
        else if let navController = segue.destination as? UINavigationController,
                let addReportController = navController.topViewController as? AddMedicalReportHostingController {
            addReportController.delegate = self
        }
    }

    // Fetch reports from the data controller
    func fetchReports() async -> [MedicalReport] {
        // First try to get reports from UserDefaults
        let localReports = loadReportsFromUserDefaults()
        
        // If we have local data and it's recent, return it without hitting backend
        if !localReports.isEmpty {
            // Store locally for other components to access
            self.reports = localReports
            
            // Only fetch from backend if we should refresh based on time
            if shouldRefresh() {
                // Fetch in background without waiting
                Task.detached {
                    await self.refreshFromBackend()
                }
            }
            
            return localReports
        }
        
        // If no local data, we need to fetch from backend
        return await refreshFromBackend()
    }
    
    // Fetch reports from backend and update UserDefaults
    private func refreshFromBackend() async -> [MedicalReport] {
        // Set refresh state
        isRefreshing = true
        lastRefreshTime = Date()
        
        // Fetch from data controller
        let fetchedReports = await DataController.shared.fetchMedicalReports()
        
        // Update local cache
        self.reports = fetchedReports
        
        // Save to UserDefaults
        saveReportsToUserDefaults(fetchedReports)
        
        // Reset refresh state
        isRefreshing = false
        
        return fetchedReports
    }
    
    // Load reports from UserDefaults
    private func loadReportsFromUserDefaults() -> [MedicalReport] {
        guard let data = UserDefaults.standard.data(forKey: "MedicalReportsCache") else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let reports = try decoder.decode([MedicalReport].self, from: data)
            return reports
        } catch {
            print("Failed to load reports from UserDefaults: \(error)")
            return []
        }
    }
    
    // Save reports to UserDefaults
    private func saveReportsToUserDefaults(_ reports: [MedicalReport]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(reports)
            UserDefaults.standard.set(data, forKey: "MedicalReportsCache")
        } catch {
            print("Failed to save reports to UserDefaults: \(error)")
        }
    }

    // Handle tab selection to refresh data when medical records tab is selected
    @objc private func handleTabBarSelection(_ notification: Notification) {
        if let selectedIndex = notification.object as? Int, 
           let tabBarController = self.tabBarController,
           selectedIndex == tabBarController.selectedIndex,
           tabBarController.selectedViewController?.children.contains(self) == true {
            
            // Only refresh if enough time has passed
            if shouldRefresh() {
                loadReports()
            }
        }
    }

    // Handle notification when a medical report is added
    @objc private func handleMedicalReportAdded(_ notification: Notification) {
        // We need to immediately update our local data
        // and refresh the UI - do this on main thread
        DispatchQueue.main.async {
            // Immediately refresh from UserDefaults
            self.reports = self.loadReportsFromUserDefaults()
            
            // Update the rootView if needed
            if self.reports != self.rootView.reports {
                print("Updating rootView with \(self.reports.count) reports")
                self.rootView.reports = self.reports
            }
            
            // Schedule a background refresh from server after a delay
            Task.detached {
                // Give UI time to update
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                _ = await self.refreshFromBackend()
            }
        }
    }

    // Load reports from data controller
    private func loadReports() {
        // Skip if already refreshing
        if isRefreshing {
            return
        }
        
        Task {
            // Fetch reports and update last refresh time
            let fetchedReports = await fetchReports()
            
            // If we didn't get reports from the fetch, don't update the view
            if fetchedReports.isEmpty && !reports.isEmpty {
                return
            }
            
            // Only update UI on main thread
            await MainActor.run {
                // Store locally and update view
                self.reports = fetchedReports
            }
        }
    }

    // Helper to determine if we should refresh based on time since last refresh
    private func shouldRefresh() -> Bool {
        // If no last refresh or more than 3 seconds since last refresh
        guard let lastRefresh = lastRefreshTime else { return true }
        let minTimeBetweenRefreshes: TimeInterval = 3.0 // seconds
        return Date().timeIntervalSince(lastRefresh) > minTimeBetweenRefreshes
    }
}

// MARK: - AddMedicalReportHostingControllerDelegate
extension MedicalRecordsHostingController: AddMedicalReportHostingControllerDelegate {
    func didAddMedicalReport() {
        // Immediately refresh from UserDefaults on main thread
        DispatchQueue.main.async {
            self.reports = self.loadReportsFromUserDefaults()
            self.rootView.reports = self.reports
        }
    }
}
