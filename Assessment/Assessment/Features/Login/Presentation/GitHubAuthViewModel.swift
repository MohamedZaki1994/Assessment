//
//  GitHubAuthViewModel.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import Foundation
import Combine

@MainActor
final class GitHubAuthViewModel: ObservableObject {
	@Published var accessToken: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
	@Published var userCode: String?
	@Published var verificationURL: URL?
	@Published var verificationURLComplete: URL?

	private let loadExistingTokenUseCase: LoadExistingTokenUseCase
	private let requestDeviceCodeUseCase: RequestDeviceCodeUseCase
	private let pollForAccessTokenUseCase: PollForAccessTokenUseCase
	private let logoutUseCase: LogoutUseCase

	init() {
		self.loadExistingTokenUseCase = LoadExistingTokenUseCase()
		self.requestDeviceCodeUseCase = RequestDeviceCodeUseCase()
		self.pollForAccessTokenUseCase = PollForAccessTokenUseCase()
		self.logoutUseCase = LogoutUseCase()
		self.accessToken = loadExistingTokenUseCase.execute()
	}

    func login() async {
        errorMessage = nil
        userCode = nil
        verificationURL = nil
        verificationURLComplete = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let device = try await requestDeviceCodeUseCase.execute()
            userCode = device.userCode
            verificationURL = URL(string: device.verificationUri)
            verificationURLComplete = device.verificationUriComplete.flatMap { URL(string: $0) }
            do {
                let accessToken = try await pollForAccessTokenUseCase.execute(
                    deviceCode: device.deviceCode,
                    interval: device.interval,
                    expiresIn: device.expiresIn
                )
                self.accessToken = accessToken
            } catch let oauthError as OAuthError {
                switch oauthError {
                case .accessDenied:
                    errorMessage = "You canceled the login on GitHub."
                case .expiredToken:
                    errorMessage = "The login code expired. Please try again."
                default:
                    errorMessage = oauthError.localizedDescription
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        } catch let oauthError as OAuthError {
            switch oauthError {
            case .accessDenied:
                errorMessage = "You canceled the login on GitHub."
            case .expiredToken:
                errorMessage = "The login code expired. Please try again."
            default:
                errorMessage = oauthError.localizedDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        logoutUseCase.execute()
        accessToken = nil
        userCode = nil
        verificationURL = nil
        verificationURLComplete = nil
    }
}
