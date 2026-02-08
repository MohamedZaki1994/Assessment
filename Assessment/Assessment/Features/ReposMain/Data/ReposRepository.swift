//
//  ReposRepository.swift
//  Assessment
//

import Foundation

final class ReposRepository {
    private let network: NetworkClient

    init(
        network: NetworkClient = NetworkClient(
            interceptor: RequestInterceptor(tokenProvider: KeychainAccessTokenProvider())
        )
    ) {
        self.network = network
    }

    func fetchUserRepos(page: Int, perPage: Int = 10) async throws -> [Repo] {
        let request = try network.makeRequest(
            endpoint: .userRepos(page: page, perPage: perPage),
            method: .get,
            body: .none
        )

        return try await network.send(request, as: [Repo].self)
    }
}
