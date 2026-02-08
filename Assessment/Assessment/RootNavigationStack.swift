//
//  RootNavigationStack.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import SwiftUI

struct RootNavigationStack: View {
    @ObservedObject var coordinator: AppCoordinator
    let isAuthenticated: Bool

    private let reposHomeViewModel: ReposHomeViewModel

    init(coordinator: AppCoordinator, isAuthenticated: Bool) {
        self.coordinator = coordinator
        self.isAuthenticated = isAuthenticated
        let fetchMyReposUseCase = FetchMyReposUseCase()
        let logoutUseCase = LogoutUseCase()
        self.reposHomeViewModel = ReposHomeViewModel()
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                if isAuthenticated {
                    ReposHomeView(viewModel: reposHomeViewModel)
                } else {
                    GitHubAuthView()
                }
            }
            .navigationDestination(for: Destination.self) { destination in
                view(for: destination)
            }
        }
    }

    @ViewBuilder
    private func view(for destination: Destination) -> some View {
        switch destination {
        case .reposHome:
            ReposHomeView(viewModel: reposHomeViewModel)
        case .repoDetails:
            RepoDetailsView()
        }
    }
}

#Preview {
    RootNavigationStack(coordinator: AppCoordinator(), isAuthenticated: false)
        .environmentObject(AuthSession())
}
