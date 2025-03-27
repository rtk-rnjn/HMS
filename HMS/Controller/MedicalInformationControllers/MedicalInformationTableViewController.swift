import UIKit
import SwiftUI

class MedicalInformationTableViewController: UIViewController {
    
    var patient: Patient? {
        didSet {
            if let patient = patient {
                updatePatient(patient)
            }
        }
    }
    
    private var hostingController: UIHostingController<MedicalProfileView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }
    
    private func setupSwiftUIView() {
        let medicalProfileView = MedicalProfileView(
            patient: Binding(
                get: { [weak self] in
                    self?.patient
                },
                set: { [weak self] newValue in
                    self?.patient = newValue
                }
            ),
            onComplete: { [weak self] in
                guard let self = self, let patient = self.patient else {
                    DispatchQueue.main.async {
                        let alert = Utils.getAlert(title: "Error", message: "Invalid patient data. Please try again.")
                        self?.present(alert, animated: true)
                    }
                    return
                }
                
                Task {
                    // Create the patient first
                    let success = await DataController.shared.createPatient(patient: patient)
                    
                    DispatchQueue.main.async {
                        if success {
                            // If patient creation is successful, try to log in
                            Task {
                                let loginSuccess = await DataController.shared.login(emailAddress: patient.emailAddress, password: patient.password)
                                
                                DispatchQueue.main.async {
                                    if loginSuccess {
                                        // Navigate to Initial storyboard
                                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                           let window = windowScene.windows.first {
                                            let storyboard = UIStoryboard(name: "Initial", bundle: nil)
                                            if let initialViewController = storyboard.instantiateInitialViewController() {
                                                window.rootViewController = initialViewController
                                                window.makeKeyAndVisible()
                                            }
                                        }
                                    } else {
                                        let alert = Utils.getAlert(title: "Error", message: "Failed to log in. Please try signing in manually.")
                                        self.present(alert, animated: true)
                                    }
                                }
                            }
                        } else {
                            let alert = Utils.getAlert(title: "Error", message: "Failed to create patient profile. Please check your information and try again.")
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        )
        
        let hostingController = UIHostingController(rootView: medicalProfileView)
        self.hostingController = hostingController
        
        // Add the hosting controller as a child
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    private func updatePatient(_ patient: Patient) {
        hostingController?.rootView = MedicalProfileView(
            patient: Binding(
                get: { [weak self] in
                    self?.patient
                },
                set: { [weak self] newValue in
                    self?.patient = newValue
                }
            ),
            onComplete: { [weak self] in
                guard let self = self, let patient = self.patient else {
                    DispatchQueue.main.async {
                        let alert = Utils.getAlert(title: "Error", message: "Invalid patient data. Please try again.")
                        self?.present(alert, animated: true)
                    }
                    return
                }
                
                Task {
                    // Create the patient first
                    let success = await DataController.shared.createPatient(patient: patient)
                    
                    DispatchQueue.main.async {
                        if success {
                            // If patient creation is successful, try to log in
                            Task {
                                let loginSuccess = await DataController.shared.login(emailAddress: patient.emailAddress, password: patient.password)
                                
                                DispatchQueue.main.async {
                                    if loginSuccess {
                                        // Navigate to Initial storyboard
                                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                           let window = windowScene.windows.first {
                                            let storyboard = UIStoryboard(name: "Initial", bundle: nil)
                                            if let initialViewController = storyboard.instantiateInitialViewController() {
                                                window.rootViewController = initialViewController
                                                window.makeKeyAndVisible()
                                            }
                                        }
                                    } else {
                                        let alert = Utils.getAlert(title: "Error", message: "Failed to log in. Please try signing in manually.")
                                        self.present(alert, animated: true)
                                    }
                                }
                            }
                        } else {
                            let alert = Utils.getAlert(title: "Error", message: "Failed to create patient profile. Please check your information and try again.")
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        )
    }
} 