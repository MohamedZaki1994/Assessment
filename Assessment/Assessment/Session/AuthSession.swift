//
//  AuthSession.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
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
