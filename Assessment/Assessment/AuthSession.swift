//
//  AuthSession.swift
//  Assessment
//

import Foundation
import Combine

@MainActor
final class AuthSession: ObservableObject {
    @Published var isAuthenticated: Bool

    init(isAuthenticated: Bool = false) {
        self.isAuthenticated = isAuthenticated
    }
}
