//
//  GitHubLoginUseCase.swift
//  Assessment
//
//  Orchestrates GitHub login using the AuthRepository.
//

import Foundation

struct GitHubLoginUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func loadExistingToken() -> String? {
        repository.currentAccessToken()
    }

    func requestDeviceCode() async throws -> DeviceCodeResponse {
        try await repository.requestDeviceCode()
    }

    func pollForAccessToken(deviceCode: String, interval: Int, expiresIn: Int) async throws -> String {
        try await repository.pollForAccessToken(deviceCode: deviceCode, interval: interval, expiresIn: expiresIn)
    }

    func logout() {
        repository.logout()
    }
}
