//
//  MiddlewareManager.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 19/03/25.
//

import Foundation

private let endpoint = "http://localhost:8080"

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

    func delete(url: String, body: Data) async -> Bool {
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
            print("Error: Could not create URL from \(urlString)")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body {
            request.httpBody = body
            // Print the request body for debugging
            if let jsonString = String(data: body, encoding: .utf8) {
                print("Request Body: \(jsonString)")
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Print response data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response Data: \(jsonString)")
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Not an HTTP response")
                return nil
            }

            print("Status code: \(httpResponse.statusCode)")

            if httpResponse.statusCode != 200 {
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Error response: \(errorJson)")
                }
                return nil
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)

        } catch {
            print("Network error: \(error)")
            return nil
        }
    }
}
