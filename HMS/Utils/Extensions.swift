//
//  Extensions.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 20/03/25.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }

        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }

    func toData(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(self)
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

    func isValidPassword() -> Bool {
        return count >= 8
    }

    func isPhoneNumber() -> Bool {
        return Int(self) != nil && count == 10
    }

    func isNumeric() -> Bool {
        return Double(self) != nil
    }
}

extension Date {
    func relativeString(from date: Date?) -> String {
        guard let date else { return "just now" }

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.maximumUnitCount = 1

        let now = Date()
        let timeInterval = round(now.timeIntervalSince(date))

        if let formattedString = formatter.string(from: abs(timeInterval)) {
            return timeInterval < 0 ? "in \(formattedString)" : "\(formattedString) ago"
        } else {
            return "just now"
        }
    }

    func humanReadableString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    func relativeInterval(from date: Date?) -> TimeInterval {
        guard let date else { return 0 }
        return abs(round(Date().timeIntervalSince(date)))
    }
}
