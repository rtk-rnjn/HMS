import UIKit
import SwiftUI

class MedicalInformationTableViewController: UIViewController {

    // MARK: Internal

    var patient: Patient? {
        didSet {
            if let patient {
                updatePatient(patient)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }

    // MARK: Private

    private var hostingController: UIHostingController<MedicalProfileView>?

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
                guard let self, let patient else {
                    DispatchQueue.main.async {
                        let alert = Utils.getAlert(title: "Error", message: "Invalid patient data. Please try again.")
                        self?.present(alert, animated: true)
                    }
                    return
                }

                Task {

                    let success = await DataController.shared.createPatient(patient: patient)

                    DispatchQueue.main.async {
                        if success {

                            Task {
                                let loginSuccess = await DataController.shared.login(emailAddress: patient.emailAddress, password: patient.password)

                                DispatchQueue.main.async {
                                    if loginSuccess {

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

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

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
                guard let self, let patient = self.patient else {
                    DispatchQueue.main.async {
                        let alert = Utils.getAlert(title: "Error", message: "Invalid patient data. Please try again.")
                        self?.present(alert, animated: true)
                    }
                    return
                }

                Task {

                    let success = await DataController.shared.createPatient(patient: patient)

                    DispatchQueue.main.async {
                        if success {

                            Task {
                                let loginSuccess = await DataController.shared.login(emailAddress: patient.emailAddress, password: patient.password)

                                DispatchQueue.main.async {
                                    if loginSuccess {

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
