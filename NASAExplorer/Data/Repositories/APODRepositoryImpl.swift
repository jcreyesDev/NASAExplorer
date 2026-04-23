import Foundation

final class APODRepositoryImpl: APODRepository {
    private let client: HTTPClient
    private let cache: QueryCache
    
    init(client: HTTPClient = APIClient(),
         cache: QueryCache = QueryCache(ttl: 300)) {
        self.client = client
        self.cache = cache
    }
    
    func fetchItems(query: String) async throws -> [APODItem] {
        let cacheKey = query.lowercased().trimmingCharacters(in: .whitespaces)
        
        if let cached = await cache.get(forKey: cacheKey) {
            return cached
        }
        
        // Cache miss — fetch from network and store result
        guard let url = Endpoints.search(query: cacheKey.isEmpty ? "space" : cacheKey).url else {
            throw APIError.invalidURL
        }
        
        let response: SearchResponseDTO = try await client.get(url: url)
        let items = APODItemMapper.map(response.collection.items)
        
        await cache.set(items, forKey: cacheKey)
        
        return items
    }
}
