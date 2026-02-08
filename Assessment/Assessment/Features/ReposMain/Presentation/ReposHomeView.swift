//
//  ReposHomeView.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import SwiftUI

struct ReposHomeView: View {
    @ObservedObject var viewModel: ReposHomeViewModel
    @EnvironmentObject private var session: AuthSession

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("My Repos")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button("Logout") {
                    viewModel.logout()
                    session.isAuthenticated = false
                }
                .buttonStyle(.bordered)
            }

            if viewModel.repos.isEmpty && viewModel.isLoading {
                // Initial load: show a full-screen spinner
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if viewModel.repos.isEmpty {
                Text("No repositories to show")
                    .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(viewModel.repos) { repo in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(repo.name)
                                .font(.headline)
                            if let fullName = repo.fullName {
                                Text(fullName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onAppear {
                            if repo.id == viewModel.repos.last?.id {
                                Task { await viewModel.loadNextPage() }
                            }
                        }
                    }

                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding()
        .task {
            await viewModel.loadFirstPage()
        }
    }
}
