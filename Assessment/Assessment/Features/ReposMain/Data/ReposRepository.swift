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
        var components = URLComponents(string: "https://api.github.com/user/repos")!
        components.queryItems = [
            URLQueryItem(name: "per_page", value: String(perPage)),
            URLQueryItem(name: "page", value: String(page))
        ]

        let request = try network.makeRequest(
            url: components.url!,
            method: .get,
            body: .none
        )

        return try await network.send(request, as: [Repo].self)
    }
}
