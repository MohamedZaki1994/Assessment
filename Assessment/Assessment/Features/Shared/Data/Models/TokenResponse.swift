//
//  TokenResponse.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

struct TokenResponse: Decodable {
    let accessToken: String?
    let scope: String?
    let tokenType: String?
    let error: String?
    let errorDescription: String?
    let errorUri: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
        case error
        case errorDescription = "error_description"
        case errorUri = "error_uri"
    }
}
