//
//  ReposRepositoryProtocol.swift
//  Assessment
//

import Foundation

protocol ReposRepositoryProtocol {
    func fetchUserRepos(page: Int, perPage: Int) async throws -> [Repo]
}
