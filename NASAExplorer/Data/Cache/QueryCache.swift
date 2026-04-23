import Foundation

private struct CacheEntry {
    let value: [APODItem]
    let timestamp: Date
}

actor QueryCache {
    private var storage: [String: CacheEntry] = [:]
    private let ttl: TimeInterval
    
    init(ttl: TimeInterval = 300) {
        self.ttl = ttl
    }
    
    func set(_ value: [APODItem], forKey key: String) {
        storage[key] = CacheEntry(value: value, timestamp: Date())
    }
    
    func get(forKey key: String) -> [APODItem]? {
        guard let entry = storage[key] else { return nil }
        
        // Remove expired entry lazily on access
        guard Date().timeIntervalSince(entry.timestamp) <= ttl else {
            storage.removeValue(forKey: key)
            
            return nil
        }
        
        return entry.value
    }
    
    func clear() {
        storage.removeAll()
    }
}
