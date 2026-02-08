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

    private let loginUseCase: GitHubLoginUseCase

    init(useCase: GitHubLoginUseCase = GitHubLoginUseCase(repository: GitHubAuthRepository())) {
        self.loginUseCase = useCase
        self.accessToken = useCase.loadExistingToken()
    }

    func login() async {
        errorMessage = nil
        userCode = nil
        verificationURL = nil
        verificationURLComplete = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let device = try await loginUseCase.requestDeviceCode()
            userCode = device.userCode
            verificationURL = URL(string: device.verificationUri)
            verificationURLComplete = device.verificationUriComplete.flatMap { URL(string: $0) }
            do {
                let accessToken = try await loginUseCase.pollForAccessToken(
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
        loginUseCase.logout()
        accessToken = nil
        userCode = nil
        verificationURL = nil
        verificationURLComplete = nil
    }
}
