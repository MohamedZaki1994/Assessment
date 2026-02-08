//
//  KeychainAccessTokenProvider.swift
//  Assessment
//

import Foundation

final class KeychainAccessTokenProvider: AccessTokenProvider {
    func currentAccessToken() -> String? {
		try? KeychainStore.read(service: Constants.keychainService, account: Constants.keychainAccount)
    }
}
