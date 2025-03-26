//
//  Utils.swift
//  HMS
//
//  Created by RITIK RANJAN on 22/03/25.
//

import UIKit
import Foundation

struct AlertActionHandler {
    let title: String
    let style: UIAlertAction.Style
    let handler: ((UIAlertAction) -> Void)?
}

enum Utils {
    @MainActor public static func getAlert(title: String, message: String, actions: [AlertActionHandler]? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        guard let actions else {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            return alert
        }

        for action in actions {
            alert.addAction(UIAlertAction(title: action.title, style: action.style, handler: action.handler))
        }

        return alert
    }

    public static func createNotification(title: String? = nil, body: String? = nil, date: Date? = nil, userInfo: [String: Any]? = nil) {
        let content = UNMutableNotificationContent()

        content.title = title ?? "HMS"
        content.body = body ?? "Reminder"
        content.sound = .defaultCritical
        content.interruptionLevel = .timeSensitive
        content.userInfo = userInfo ?? [:]

        let timeInterval = Date().relativeInterval(from: date)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    public static func getGreetigs() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<24:
            return "Good Evening"
        default:
            return "Hello"
        }
    }
}
