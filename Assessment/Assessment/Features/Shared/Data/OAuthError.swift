//
//  OAuthError.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import Foundation

enum OAuthError: LocalizedError {
    case invalidDeviceCodeResponse
    case invalidTokenResponse
    case authorizationPending
    case slowDown
    case accessDenied
    case expiredToken
    case unsupportedError(String)

    var errorDescription: String? {
        switch self {
        case .invalidDeviceCodeResponse:
            return "Invalid device code response"
        case .invalidTokenResponse:
            return "Invalid token response"
        case .authorizationPending:
            return "Authorization pending"
        case .slowDown:
            return "Slow down"
        case .accessDenied:
            return "Access denied"
        case .expiredToken:
            return "Expired token"
        case .unsupportedError(let message):
            return message
        }
    }
}
