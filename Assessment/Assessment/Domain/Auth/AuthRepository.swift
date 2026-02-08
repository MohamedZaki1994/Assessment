//
//  AuthRepository.swift
//  Assessment
//
//  Defines the abstraction for authentication-related data operations.
//

import Foundation

protocol AuthRepository {
    func currentAccessToken() -> String?
    func requestDeviceCode() async throws -> DeviceCodeResponse
    func pollForAccessToken(deviceCode: String, interval: Int, expiresIn: Int) async throws -> String
    func logout()
}
