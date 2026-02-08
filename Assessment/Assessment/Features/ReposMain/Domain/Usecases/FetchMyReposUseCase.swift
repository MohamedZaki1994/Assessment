//
//  FetchMyReposUseCase.swift
//  Assessment
//

import Foundation

struct FetchMyReposUseCase {
    private let repository: ReposRepositoryProtocol

    init(repository: ReposRepositoryProtocol = ReposRepository()) {
        self.repository = repository
    }

    func execute(page: Int, perPage: Int = 10) async throws -> [Repo] {
        try await repository.fetchUserRepos(page: page, perPage: perPage)
    }
}
