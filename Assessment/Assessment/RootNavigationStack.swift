//
//  RootNavigationStack.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import SwiftUI

struct RootNavigationStack: View {
	@EnvironmentObject private var coordinator: AppCoordinator
    let isAuthenticated: Bool

    init(isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                if isAuthenticated {
                    ReposHomeView()
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
            ReposHomeView()
        case .repoDetails:
            RepoDetailsView()
        }
    }
}

#Preview {
    RootNavigationStack(isAuthenticated: false)
        .environmentObject(AuthSession())
}
