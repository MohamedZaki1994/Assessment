//
//  LoadExistingTokenUseCase.swift
//  Assessment
//

import Foundation

struct LoadExistingTokenUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository = GitHubAuthRepository()) {
        self.repository = repository
    }

    func execute() -> String? {
        repository.currentAccessToken()
    }
}
