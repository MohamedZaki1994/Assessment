//
//  ContentView.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var session: AuthSession
    @StateObject private var viewModel: ContentViewModel

    init(session: AuthSession) {
        _session = StateObject(wrappedValue: session)
        _viewModel = StateObject(wrappedValue: ContentViewModel(session: session))
    }

    var body: some View {
        RootNavigationStack(isAuthenticated: viewModel.isAuthenticated)
            .environmentObject(session)
            .task {
                await Task { viewModel.refreshAuthState() }.value
            }
    }
}

#Preview {
    ContentView(session: AuthSession())
}
