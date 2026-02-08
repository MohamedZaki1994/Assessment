//
//  HTTPBody.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//


import Foundation

enum HTTPBody {
    case none
    case json(Codable)
    case formURLEncoded([URLQueryItem])

    func build() throws -> (data: Data?, contentType: String?) {
        switch self {
        case .none:
            return (nil, nil)
        case .json(let codable):
            let data = try JSONEncoder().encode(codable)
            return (data, "application/json")
        case .formURLEncoded(let items):
            var components = URLComponents()
            components.queryItems = items
            let data = components.query?.data(using: .utf8)
            return (data, "application/x-www-form-urlencoded")
        }
    }
}
