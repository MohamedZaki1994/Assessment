//
//  ReposHomeViewModel.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import Foundation
import Combine

@MainActor
final class ReposHomeViewModel: ObservableObject {
    @Published private(set) var repos: [Repo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let logoutUseCase: LogoutUseCase
    private let fetchMyReposUseCase: FetchMyReposUseCase

    private var currentPage: Int = 1
    private var canLoadMore: Bool = true

    init(logoutUseCase: LogoutUseCase, fetchMyReposUseCase: FetchMyReposUseCase) {
        self.logoutUseCase = logoutUseCase
        self.fetchMyReposUseCase = fetchMyReposUseCase
    }

    convenience init() {
        self.init(
            logoutUseCase: LogoutUseCase(),
            fetchMyReposUseCase: FetchMyReposUseCase()
        )
    }

    func loadFirstPage() async {
        currentPage = 1
        canLoadMore = true
        repos = []
        await loadNextPage()
    }

    func loadNextPage() async {
        guard canLoadMore, !isLoading else { return }

        isLoading = true
        errorMessage = nil
        do {
            let newRepos = try await fetchMyReposUseCase.execute(page: currentPage, perPage: 10)
            repos.append(contentsOf: newRepos)
            if newRepos.isEmpty {
                canLoadMore = false
            } else {
                currentPage += 1
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func logout() {
        logoutUseCase.execute()
    }
}
