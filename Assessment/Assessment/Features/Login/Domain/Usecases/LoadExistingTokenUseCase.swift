//
//  LoadExistingTokenUseCase.swift
//  Assessment
//

import Foundation

protocol LoadExistingTokenUseCaseProtocol {
    func execute() -> String?
}

struct LoadExistingTokenUseCase: LoadExistingTokenUseCaseProtocol {
    private let repository: AuthRepository

    init(repository: AuthRepository = GitHubAuthRepository()) {
        self.repository = repository
    }

    func execute() -> String? {
        repository.currentAccessToken()
    }
}
