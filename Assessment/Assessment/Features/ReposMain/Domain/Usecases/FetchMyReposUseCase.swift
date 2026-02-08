//
//  FetchMyReposUseCase.swift
//  Assessment
//

import Foundation

struct FetchMyReposUseCase {
    private let repository: ReposRepository

    init(repository: ReposRepository) {
        self.repository = repository
    }

    init() {
        self.repository = ReposRepository()
    }

    func execute(page: Int, perPage: Int = 10) async throws -> [Repo] {
        try await repository.fetchUserRepos(page: page, perPage: perPage)
    }
}
