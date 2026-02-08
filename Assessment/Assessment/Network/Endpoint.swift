import Foundation

enum Endpoint {
    case deviceCode
    case accessToken
    case userRepos(page: Int, perPage: Int)

    var path: String {
        switch self {
        case .deviceCode:
            return "/login/device/code"
        case .accessToken:
            return "/login/oauth/access_token"
        case .userRepos:
            return "/user/repos"
        }
    }

    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        
        switch self {
        case .deviceCode, .accessToken:
            components.host = "github.com"
        case .userRepos:
            components.host = "api.github.com"
        }
        
        components.path = path
        
        switch self {
        case .userRepos(let page, let perPage):
            components.queryItems = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
        default:
            break
        }
        
        return components.url!
    }
}
