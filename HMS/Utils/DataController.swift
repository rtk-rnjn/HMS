//
//  DataController.swift
//  HMS
//
//  Created by RITIK RANJAN on 23/03/25.
//

import Foundation
import UIKit

struct Token: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user = "user"
    }

    var accessToken: String
    var tokenType: String = "bearer"
    var user: Patient?
}

struct UserLogin: Codable {
    enum CodingKeys: String, CodingKey {
        case emailAddress = "email_address"
        case password
    }

    var emailAddress: String
    var password: String
}

struct ServerResponse: Codable {
    var success: Bool
}

struct ChangePassword: Codable {
    enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case newPassword = "new_password"
    }

    var oldPassword: String
    var newPassword: String
}

struct HardPasswordReset: Codable {
    enum CodingKeys: String, CodingKey {
        case emailAddress = "email_address"
        case newPassword = "new_password"
    }

    var emailAddress: String
    var newPassword: String
}

class DataController {

    // MARK: Public

    public private(set) var patient: Patient?

    // MARK: Internal

    @MainActor static let shared: DataController = .init()

    func login(emailAddress: String, password: String) async -> Bool {
        let userLogin = UserLogin(emailAddress: emailAddress, password: password)
        guard let userLoginData = userLogin.toData() else {
            fatalError("Could not convert UserLogin to Data")
        }

        let token: Token? = await MiddlewareManager.shared.post(url: "/patient/login", body: userLoginData)
        guard let accessToken = token?.accessToken, let patient = token?.user else {
            return false
        }
        self.accessToken = accessToken
        self.patient = patient

        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(emailAddress, forKey: "emailAddress")
        UserDefaults.standard.set(password, forKey: "password")

        return true
    }

    func autoLogin() async -> Bool {
        guard let email = UserDefaults.standard.string(forKey: "emailAddress"),
              let password = UserDefaults.standard.string(forKey: "password") else {
            return false
        }

        return await login(emailAddress: email, password: password)
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "isUserLoggedIn")
    }

    func fetchDoctors() async -> [Staff]? {
        return await MiddlewareManager.shared.get(url: "/staffs", queryParameters: ["limit": "100"])
    }

    func createPatient(patient: Patient) async -> Bool {
        guard let patientData = patient.toData() else {
            fatalError("Could not create patient")
        }

        let response: ServerResponse? = await MiddlewareManager.shared.post(url: "/patient/create", body: patientData)
        let success = response?.success ?? false

        if success {
            self.patient = patient
        }

        return success
    }

    func changePassword(oldPassword: String, newPassword: String) async -> Bool {
        let changePassword = ChangePassword(oldPassword: oldPassword, newPassword: newPassword)
        guard let changePasswordData = changePassword.toData() else {
            fatalError("Could not change password")
        }

        let response: ServerResponse? = await MiddlewareManager.shared.patch(url: "/patient/change-password", body: changePasswordData)
        let success = response?.success ?? false
        if success {
            UserDefaults.standard.set(newPassword, forKey: "password")
        }
        return success
    }

    func hardPasswordReset(emailAddress: String, password: String) async -> Bool {
        let hardPasswordReset = HardPasswordReset(emailAddress: emailAddress, newPassword: password)
        guard let hardPasswordResetData = hardPasswordReset.toData() else {
            fatalError("Could not hard reset password")
        }

        let response: ServerResponse? = await MiddlewareManager.shared.patch(url: "/change-password", body: hardPasswordResetData)
        return response?.success ?? false
    }

    func requestOtp(emailAddress: String) async -> Bool {
        let response: ServerResponse? = await MiddlewareManager.shared.get(url: "/request-otp", queryParameters: ["to_email": emailAddress])
        return response?.success ?? false
    }

    func verifyOtp(emailAddress: String, otp: String) async -> Bool {
        let response: ServerResponse? = await MiddlewareManager.shared.get(url: "/verify-otp", queryParameters: ["to_email": emailAddress, "otp": otp])
        return response?.success ?? false
    }
    
    // MARK: Medical Reports
    
    func saveMedicalReport(_ report: MedicalReport) async -> Bool {
        // Save the report to local storage for now
        // In a real app, this would typically save to a backend server
        var reports = getMedicalReports()
        reports.append(report)
        
        do {
            let data = try JSONEncoder().encode(reports)
            UserDefaults.standard.set(data, forKey: "medical_reports")
            return true
        } catch {
            print("Failed to save medical report: \(error)")
            return false
        }
    }
    
    func getMedicalReports() -> [MedicalReport] {
        guard let data = UserDefaults.standard.data(forKey: "medical_reports") else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([MedicalReport].self, from: data)
        } catch {
            print("Failed to load medical reports: \(error)")
            return []
        }
    }
    
    func uploadImage(_ image: UIImage) async -> String? {
        // In a real app, this would upload to a server and return the URL
        // For now, we'll save locally and return a dummy URL
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        let filename = "\(UUID().uuidString).jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        
        do {
            try data.write(to: url)
            return url.path
        } catch {
            print("Failed to save image: \(error)")
            return nil
        }
    }

    // MARK: Private

    private var accessToken: String = ""
}
