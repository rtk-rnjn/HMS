//
//  DataController.swift
//  HMS
//
//  Created by RITIK RANJAN on 23/03/25.
//

import Foundation
import EventKit

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
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.set(patient.id, forKey: "patientId")

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
        UserDefaults.standard.removeObject(forKey: "emailAddress")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "patientId")
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

    func fetchDoctor(bySpecialization specialization: String) async -> [Staff]? {
        let endpoint = "/search/doctors/specialization"
        return await MiddlewareManager.shared.get(url: endpoint, queryParameters: ["query": specialization])
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

    func bookAppointment(_ appointment: Appointment) async -> Bool {
        var thisAppointment = appointment
        thisAppointment.patientId = patient?.id ?? ""

        guard let appointmentData = thisAppointment.toData() else {
            fatalError("Could not book appointment")
        }

        let response: ServerResponse? = await MiddlewareManager.shared.post(url: "/appointment/create", body: appointmentData)
        return response?.success ?? false
    }

    func fetchAppointments() async -> [Appointment] {
        let id = UserDefaults.standard.string(forKey: "patientId")
        let appointments: [Appointment]? = await MiddlewareManager.shared.get(url: "/appointments/\(id ?? "")")
        guard var appointments else {
            return []
        }

        for i in 0..<appointments.count {
            appointments[i].doctor = await MiddlewareManager.shared.get(url: "/staff/\(appointments[i].doctorId)")
            appointments[i].patient = patient
        }
        return appointments
    }

    func fetchPrescriptions() async -> [Prescription] {
        guard let id = UserDefaults.standard.string(forKey: "patientId") else {
            return []
        }

        let prescriptions: [Prescription]? = await MiddlewareManager.shared.get(url: "/patient/\(id)/prescription")
        return prescriptions ?? []
    }

    func fetchMedicalReports() async -> [MedicalReport] {
        if patient == nil {
            guard await autoLogin() else { fatalError() }
        }

        guard let patient else {
            fatalError("Patient is nil")
        }

        let reports: [MedicalReport]? = await MiddlewareManager.shared.get(url: "/patient/\(patient.id)/medical-reports")
        return reports ?? []
    }

    func deleteAppointment(_ appointmentId: String) async -> Bool {
        guard let patientId = UserDefaults.standard.string(forKey: "patientId") else {
            print("Error: No patient ID found")
            return false
        }
        
        let endpoint = "/appointments/\(patientId)/\(appointmentId)"
        print("Making DELETE request to: \(endpoint)")
        
        return await MiddlewareManager.shared.delete(url: endpoint, body: Data())
    }

    // MARK: Private

    private var accessToken: String = ""

}

extension DataController {
    public static func createEvent(appointment: Appointment) {
        let store = InitialTabBarController.eventStore

        let event = EKEvent(eventStore: store)
        event.title = "Appointment with \(appointment.doctor?.fullName ?? "Doctor")"
        event.startDate = appointment.startDate
        event.endDate = appointment.endDate
        event.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(event, span: .thisEvent)
        } catch {
            print("Error saving event: \(error)")
        }
    }
}
