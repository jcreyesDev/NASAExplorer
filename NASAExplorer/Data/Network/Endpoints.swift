import Foundation

enum Endpoints {
    private static let baseURL = "https://images-api.nasa.gov"
    
    case search(query: String)
    
    var url: URL? {
        switch self {
            case .search(let query):
                var components = URLComponents(string: "\(Self.baseURL)/search")
                
                components?.queryItems = [URLQueryItem(name: "q", value: query),
                                          URLQueryItem(name: "media_type", value: "image"),
                                          URLQueryItem(name: "page_size", value: "20")]
                
                return components?.url
        }
    }
}
