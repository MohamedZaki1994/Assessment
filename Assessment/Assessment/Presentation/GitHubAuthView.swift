//
//  GitHubAuthView.swift
//  Assessment
//
//  Created by Mohamed Zaki on 08/02/2026.
//

import SwiftUI
import UIKit

struct GitHubAuthView: View {
    @ObservedObject var auth: GitHubAuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Sign in with GitHub to continue")
                .foregroundStyle(.secondary)

            if let code = auth.userCode {
                VStack(spacing: 8) {
                    Text("Code")
                        .font(.headline)

                    Text(code)
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    if let url = auth.verificationURLComplete ?? auth.verificationURL {
                        Button("Open GitHub to verify") {
                            UIApplication.shared.open(url)
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Text("Open https://github.com/login/device in your browser and enter the code.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    if auth.isLoading {
                        Text("Waiting for approval on GitHub...")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Button {
                Task { await auth.login() }
            } label: {
                HStack {
                    if auth.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                    Text(auth.isLoading ? "Waiting..." : "Continue with GitHub")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .disabled(auth.isLoading)

            if let errorMessage = auth.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
	GitHubAuthView(auth: GitHubAuthViewModel())
}
