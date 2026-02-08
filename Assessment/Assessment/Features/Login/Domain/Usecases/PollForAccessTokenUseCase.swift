//
//  PollForAccessTokenUseCase.swift
//  Assessment
//

import Foundation

struct PollForAccessTokenUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository = GitHubAuthRepository()) {
        self.repository = repository
    }

    func execute(deviceCode: String, interval: Int, expiresIn: Int) async throws -> String {
        try await repository.pollForAccessToken(deviceCode: deviceCode, interval: interval, expiresIn: expiresIn)
    }
}
