//
//  RequestDeviceCodeUseCase.swift
//  Assessment
//

import Foundation

struct RequestDeviceCodeUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository = GitHubAuthRepository()) {
        self.repository = repository
    }

    func execute() async throws -> DeviceCodeResponse {
        try await repository.requestDeviceCode()
    }
}
