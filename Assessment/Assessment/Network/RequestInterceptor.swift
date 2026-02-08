import Foundation

struct RequestInterceptor {
    var defaultHeaders: [String: String] = [
        "Accept": "application/json"
    ]

    func intercept(_ request: inout URLRequest) {
        for (key, value) in defaultHeaders {
            if request.value(forHTTPHeaderField: key) == nil {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
    }
}
