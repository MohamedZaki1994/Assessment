//
//  Repo.swift
//  Assessment
//

import Foundation

struct Repo: Decodable, Identifiable {
    let id: Int
    let name: String
    let fullName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
    }
}
