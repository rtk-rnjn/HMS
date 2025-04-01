//
//  InitialTabBarController.swift
//  HMS
//
//  Created by RITIK RANJAN on 21/03/25.
//

import UIKit
@preconcurrency import UserNotifications
import EventKit

class InitialTabBarController: UITabBarController, UITabBarControllerDelegate {

    static var eventStore: EKEventStore = .init()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate = self
        checkForAuthentication()

        Task {
            await requestAccessForNotification()

            await requestAccessForCalendar()
            await requestAccessForReminders()

            await fetchPrescriptions()
        }

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func checkForAuthentication() {
        guard DataController.shared.patient == nil else { return }

        Task {
            let success = await DataController.shared.autoLogin()
            guard !success else { return }
            DispatchQueue.main.async {
                let action = AlertActionHandler(title: "OK", style: .default) { _ in
                    DataController.shared.logout()
                    self.performSegue(withIdentifier: "segueShowSignInViewController", sender: self)
                }
                let alert = Utils.getAlert(title: "Error", message: "Authentication Failed. Please login again.", actions: [action])
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func requestAccessForNotification() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                let settings = await center.notificationSettings()
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func requestAccessForCalendar() async {
        let status = EKEventStore.authorizationStatus(for: .event)

        switch status {
        case .denied, .restricted, .notDetermined:
            let store = EKEventStore()
            do {
                let success = try await store.requestFullAccessToEvents()
                if success {
                    DispatchQueue.main.async {
                        InitialTabBarController.eventStore = store
                    }
                }
            } catch {
                print("Error: \(error)")
            }

        default:
            break
        }
    }

    func requestAccessForReminders() async {
        let status = EKEventStore.authorizationStatus(for: .reminder)

        switch status {
        case .denied, .restricted, .notDetermined:
            let store = EKEventStore()
            do {
                let success = try await store.requestFullAccessToReminders()
                if success {
                    DispatchQueue.main.async {
                        InitialTabBarController.eventStore = store
                    }
                }
            } catch {
                print(error)
            }

        default:
            break
        }
    }

    func fetchPrescriptions() async {
        let prescriptions = await DataController.shared.fetchPrescriptions()
        for prescription in prescriptions {
            createReminder(for: prescription)
        }
    }

    func createReminder(for prescription: Prescription) {
        let eventStore = InitialTabBarController.eventStore

        for medicine in prescription.medicines {
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = "\(medicine.name) - \(medicine.dosage)"
            reminder.notes = "Prescription for: \(prescription.diagnosis)"
            reminder.calendar = eventStore.defaultCalendarForNewReminders()

            var alarm: EKAlarm? = EKAlarm()

            switch medicine.frequency {
            case let .interval(hours):
                let dueDate = Calendar.current.date(byAdding: .hour, value: hours, to: Date())
                alarm = EKAlarm(absoluteDate: dueDate ?? Date())

            case let .daily(times):
                for time in times {
                    let date = Calendar.current.date(from: time) ?? Date()
                    let dailyAlarm = EKAlarm(absoluteDate: date)
                    reminder.addAlarm(dailyAlarm)
                }

            case let .weekly(days, time):
                for day in days {
                    var components = time
                    components.weekday = day
                    let date = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime) ?? Date()
                    let weeklyAlarm = EKAlarm(absoluteDate: date)
                    reminder.addAlarm(weeklyAlarm)
                }

            case let .custom(time):
                let date = Calendar.current.date(from: time) ?? Date()
                alarm = EKAlarm(absoluteDate: date)
            }

            if let validAlarm = alarm {
                reminder.addAlarm(validAlarm)
            }

            do {
                try eventStore.save(reminder, commit: true)
            } catch {
                print("Error saving reminder: \(error.localizedDescription)")
            }
        }
    }
}
