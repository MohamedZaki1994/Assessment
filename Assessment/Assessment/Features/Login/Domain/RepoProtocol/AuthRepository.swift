//
//  AuthRepository.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import Foundation

protocol AuthRepository {
    func currentAccessToken() -> String?
    func requestDeviceCode() async throws -> DeviceCodeResponse
    func pollForAccessToken(deviceCode: String, interval: Int, expiresIn: Int) async throws -> String
    func logout()
}
