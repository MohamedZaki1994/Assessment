//
//  ContentView.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var auth = GitHubAuthViewModel()

    var body: some View {
        Group {
            if auth.accessToken == nil {
				GitHubAuthView(auth: auth)
            } else {
                VStack(spacing: 12) {
                    Text("Logged in")
                        .font(.title)
                        .fontWeight(.semibold)

                    Button("Logout") {
                        auth.logout()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
