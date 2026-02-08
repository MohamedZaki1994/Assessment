//
//  GitHubOAuthClient.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import Foundation

struct GitHubOAuthClient {
    private let network: NetworkClient
	let clientId = "Ov23liZyz3Wdcy2lzrP0"
	let scopes = "repo read:user"

    init(network: NetworkClient = NetworkClient()) {
        self.network = network
    }

    func requestDeviceCode() async throws -> DeviceCodeResponse {
        let request = try network.makeRequest(
            endpoint: .deviceCode,
            method: .post,
            body: .formURLEncoded([
                URLQueryItem(name: "client_id", value: clientId),
                URLQueryItem(name: "scope", value: scopes)
            ])
        )

        let decoded: DeviceCodeResponse = try await network.send(request)

        guard !decoded.deviceCode.isEmpty, !decoded.userCode.isEmpty, !decoded.verificationUri.isEmpty else {
            throw OAuthError.invalidDeviceCodeResponse
        }

        return decoded
    }

    func pollForAccessToken(deviceCode: String) async throws -> TokenResponse {
        let request = try network.makeRequest(
            endpoint: .accessToken,
            method: .post,
            body: .formURLEncoded([
                URLQueryItem(name: "client_id", value: clientId),
                URLQueryItem(name: "device_code", value: deviceCode),
                URLQueryItem(name: "grant_type", value: "urn:ietf:params:oauth:grant-type:device_code")
            ])
        )

        let decoded: TokenResponse = try await network.send(request)

        if let token = decoded.accessToken, !token.isEmpty {
            return decoded
        }

        if let error = decoded.error {
            switch error {
            case "authorization_pending":
                throw OAuthError.authorizationPending
            case "slow_down":
                throw OAuthError.slowDown
            case "access_denied":
                throw OAuthError.accessDenied
            case "expired_token":
                throw OAuthError.expiredToken
            default:
                let message = decoded.errorDescription ?? error
                throw OAuthError.unsupportedError(message)
            }
        }

        throw OAuthError.invalidTokenResponse
    }
}
