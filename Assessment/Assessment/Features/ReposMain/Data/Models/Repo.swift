//
//  Repo.swift
//  Assessment
//

import Foundation

struct Repo: Decodable, Identifiable {
    let id: Int
    let name: String
    let fullName: String?
    let isPrivate: Bool?
    let stargazersCount: Int?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case stargazersCount = "stargazers_count"
        case updatedAt = "updated_at"
    }
}
