import Foundation

struct RequestInterceptor {
    private let tokenProvider: AccessTokenProvider?
    private let defaultHeaders: [String: String]

    init(
        tokenProvider: AccessTokenProvider? = nil,
        defaultHeaders: [String: String] = [
            "Accept": "application/json"
        ]
    ) {
        self.tokenProvider = tokenProvider
        self.defaultHeaders = defaultHeaders
    }

    func intercept(_ request: inout URLRequest) {
        for (key, value) in defaultHeaders {
            if request.value(forHTTPHeaderField: key) == nil {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        if let token = tokenProvider?.currentAccessToken(),
		   !token.isEmpty,
		   request.value(forHTTPHeaderField: "Authorization") == nil {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
}
