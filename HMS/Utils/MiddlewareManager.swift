//
//  MiddlewareManager.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 19/03/25.
//

import Foundation

private let endpoint = "http://13.233.139.216:8080"

actor MiddlewareManager {

    // MARK: Public

    public static let shared: MiddlewareManager = .init()

    // MARK: Internal

    func get<T: Codable>(url: String, queryParameters: [String: String]? = nil) async -> T? {
        return await request(url: url, method: "GET", queryParameters: queryParameters)
    }

    func post<T: Codable>(url: String, body: Data) async -> T? {
        return await request(url: url, method: "POST", body: body)
    }

    func put<T: Codable>(url: String, body: Data) async -> T? {
        return await request(url: url, method: "PUT", body: body)
    }

    func patch<T: Codable>(url: String, body: Data) async -> T? {
        return await request(url: url, method: "PATCH", body: body)
    }

    func delete(url: String, body: Data?) async -> Bool {
        let result: Bool? = await request(url: url, method: "DELETE", body: body)
        return result != nil
    }

    // MARK: Private

    private func request<T: Codable>(url: String = "", method: String, body: Data? = nil, queryParameters: [String: String]? = nil) async -> T? {
        var urlString = "\(endpoint)\(url)"

        if let queryParameters, !queryParameters.isEmpty {
            var urlComponents = URLComponents(string: urlString)
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlString = urlComponents?.url?.absoluteString ?? urlString
        }

        guard let url = URL(string: urlString) else {
            Utils.logger.error("Error: Could not create URL from \(urlString)")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body {
            request.httpBody = body
            // Print the request body for debugging
            if let jsonString = String(data: body, encoding: .utf8) {
                Utils.logger.debug("Request Data: \(jsonString)")
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let jsonString = String(data: data, encoding: .utf8) {
                Utils.logger.debug("Response Data: \(jsonString)")
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                Utils.logger.error("Error: Could not get HTTP response")
                return nil
            }

            Utils.logger.debug("HTTP Status Code: \(httpResponse.statusCode)")

            if httpResponse.statusCode != 200 {
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    Utils.logger.error("Error: \(errorJson)")
                }
                return nil
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)

        } catch {
            Utils.logger.critical("\(#function) Error: \(error)")
            return nil
        }
    }
}
