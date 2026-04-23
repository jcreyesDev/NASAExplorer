import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
            case .invalidURL:        return "Invalid URL."
            case .invalidResponse:   return "Invalid server response."
            case .statusCode(let c): return "Server error with status code: \(c)."
            case .decoding(let e):   return "Decoding error: \(e.localizedDescription)"
        }
    }
}

protocol HTTPClient {
    func get<T: Decodable>(url: URL) async throws -> T
}

final class APIClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.statusCode(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
