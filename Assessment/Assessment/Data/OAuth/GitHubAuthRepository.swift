//
//  GitHubAuthRepository.swift
//  Assessment
//
//  Concrete implementation of AuthRepository using GitHubOAuthClient and KeychainStore.
//

import Foundation

final class GitHubAuthRepository: AuthRepository {
    private let oauthClient: GitHubOAuthClient
    private let keychainService = "Assessment"
    private let keychainAccount = "github_access_token"

    init(oauthClient: GitHubOAuthClient = GitHubOAuthClient()) {
        self.oauthClient = oauthClient
    }

    func currentAccessToken() -> String? {
        try? KeychainStore.read(service: keychainService, account: keychainAccount)
    }

    func requestDeviceCode() async throws -> DeviceCodeResponse {
        try await oauthClient.requestDeviceCode()
    }

    func pollForAccessToken(deviceCode: String, interval: Int, expiresIn: Int) async throws -> String {
        var intervalNs = UInt64(max(interval, 1)) * 1_000_000_000
        let deadline = Date().addingTimeInterval(TimeInterval(expiresIn))

        while Date() < deadline {
            do {
                let tokenResponse = try await oauthClient.pollForAccessToken(deviceCode: deviceCode)
                guard let accessToken = tokenResponse.accessToken else {
                    throw OAuthError.invalidTokenResponse
                }

                try KeychainStore.save(accessToken, service: keychainService, account: keychainAccount)
                return accessToken
            } catch let oauthError as OAuthError {
                switch oauthError {
                case .authorizationPending:
                    try await Task.sleep(nanoseconds: intervalNs)
                case .slowDown:
                    intervalNs += 5_000_000_000
                    try await Task.sleep(nanoseconds: intervalNs)
                case .accessDenied:
                    throw oauthError
                case .expiredToken:
                    throw oauthError
                default:
                    throw oauthError
                }
            }
        }

        throw OAuthError.expiredToken
    }

    func logout() {
        KeychainStore.delete(service: keychainService, account: keychainAccount)
    }
}
