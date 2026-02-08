//
//  ReposHomeView.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import SwiftUI

struct ReposHomeView: View {
    @StateObject var viewModel: ReposHomeViewModel = ReposHomeViewModel()
    @EnvironmentObject private var session: AuthSession
    @EnvironmentObject private var coordinator: AppCoordinator

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
                ProgressView()
				Spacer()
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
                            HStack {
                                Text(repo.name)
                                    .font(.headline)
                                Spacer()
								Text((repo.isPrivate ?? false) ? "Private": "Public")
                            }

                            if let fullName = repo.fullName {
                                Text(fullName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            HStack {
								if let stargazersCount = repo.stargazersCount {
									Image(systemName: "star.fill")
									Text("\(stargazersCount)")
								}
                                Spacer()
								if let updatedAt = repo.updatedAt {
									Text("Updated \(updatedAt)")
								}
                            }
                            .padding(.top, 4)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            coordinator.append(.repoDetails)
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
