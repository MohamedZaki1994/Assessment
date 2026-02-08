//
//  LogoutUseCase.swift
//  Assessment
//

import Foundation

protocol LogoutUseCaseProtocol {
    func execute()
}

struct LogoutUseCase: LogoutUseCaseProtocol {
    private let repository: AuthRepository

    init(repository: AuthRepository = GitHubAuthRepository()) {
        self.repository = repository
    }

    func execute() {
        repository.logout()
    }
}
