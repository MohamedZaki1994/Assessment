//
//  RequestDeviceCodeUseCase.swift
//  Assessment
//

import Foundation

protocol RequestDeviceCodeUseCaseProtocol {
    func execute() async throws -> DeviceCodeResponse
}

struct RequestDeviceCodeUseCase: RequestDeviceCodeUseCaseProtocol {
    private let repository: AuthRepository

    init(repository: AuthRepository = GitHubAuthRepository()) {
        self.repository = repository
    }

    func execute() async throws -> DeviceCodeResponse {
        try await repository.requestDeviceCode()
    }
}
