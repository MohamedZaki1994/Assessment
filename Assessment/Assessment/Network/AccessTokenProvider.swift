//
//  AccessTokenProvider.swift
//  Assessment
//

import Foundation

protocol AccessTokenProvider {
    func currentAccessToken() -> String?
}
