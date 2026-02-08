//
//  NetworkError.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case nonHTTPResponse
    case httpStatus(Int, Data)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .nonHTTPResponse:
            return "Non-HTTP response"
        case .httpStatus(let code, _):
            return "HTTP error: \(code)"
        case .decoding(let error):
            return "Decoding error: \(error.localizedDescription)"
        }
    }
}
