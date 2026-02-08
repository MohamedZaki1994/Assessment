//
//  AssessmentApp.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import SwiftUI

@main
struct AssessmentApp: App {
    @StateObject private var session = AuthSession()

    var body: some Scene {
        WindowGroup {
            ContentView(session: session)
        }
    }
}
