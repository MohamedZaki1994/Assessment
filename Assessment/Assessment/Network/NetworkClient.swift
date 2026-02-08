//
//  NetworkClient.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//


import Foundation

struct NetworkClient {
    var session: URLSession
    var interceptor: RequestInterceptor

    init(
        session: URLSession = .shared,
        interceptor: RequestInterceptor = RequestInterceptor()
    ) {
        self.session = session
        self.interceptor = interceptor
    }

    func makeRequest(
        endpoint: Endpoint,
        method: HTTPMethod,
        body: HTTPBody = .none,
        headers: [String: String] = [:]
    ) throws -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = method.rawValue

        let bodyBuilt = try body.build()
        request.httpBody = bodyBuilt.data
        if let contentType = bodyBuilt.contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        var intercepted = request
        interceptor.intercept(&intercepted)
        return intercepted
    }

    func send<T: Decodable>(_ request: URLRequest, as type: T.Type = T.self) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw NetworkError.nonHTTPResponse }

        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.httpStatus(http.statusCode, data)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
