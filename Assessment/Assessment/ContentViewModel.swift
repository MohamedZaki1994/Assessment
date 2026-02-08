//
//  ContentViewModel.swift
//  Assessment
//

import Foundation
import Combine

@MainActor
final class ContentViewModel: ObservableObject {
    @Published private(set) var isAuthenticated: Bool = false

    private let session: AuthSession
    private let loadExistingTokenUseCase: LoadExistingTokenUseCase
    private var cancellables = Set<AnyCancellable>()

    init(
        session: AuthSession,
        loadExistingTokenUseCase: LoadExistingTokenUseCase = LoadExistingTokenUseCase(repository: GitHubAuthRepository())
    ) {
        self.session = session
        self.loadExistingTokenUseCase = loadExistingTokenUseCase

        let hasToken = loadExistingTokenUseCase.execute() != nil
        self.isAuthenticated = hasToken

        session.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isAuthenticated = value
            }
            .store(in: &cancellables)
    }

    func refreshAuthState() {
        let hasToken = loadExistingTokenUseCase.execute() != nil
        DispatchQueue.main.async { [weak self] in
            self?.session.isAuthenticated = hasToken
            self?.isAuthenticated = hasToken
        }
    }
}
