//
//  LogoutUseCase.swift
//  Assessment
//

import Foundation

struct LogoutUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository = GitHubAuthRepository()) {
        self.repository = repository
    }

    func execute() {
        repository.logout()
    }
}
