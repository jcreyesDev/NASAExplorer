import XCTest
@testable import NASAExplorer

final class QueryCacheTests: XCTestCase {
    
    func test_get_returnsValue_whenCacheIsValid() async {
        let sut = QueryCache(ttl: 60)
        let item = makeAPODItem(id: "1")
        await sut.set([item], forKey: "key1")
        
        let result = await sut.get(forKey: "key1")
        
        let id = await result?.first?.id
        XCTAssertEqual(id, "1")
    }
    
    func test_get_returnsNil_whenKeyDoesNotExist() async {
        let sut = QueryCache(ttl: 60)
        
        let result = await sut.get(forKey: "nonexistent")
        
        XCTAssertNil(result)
    }
    
    func test_get_returnsNil_whenCacheHasExpired() async throws {
        let sut = QueryCache(ttl: 1)
        await sut.set([makeAPODItem(id: "1")], forKey: "key1")
        
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        let result = await sut.get(forKey: "key1")
        XCTAssertNil(result)
    }
    
    func test_set_overwritesExistingValue() async {
        let sut = QueryCache(ttl: 60)
        await sut.set([makeAPODItem(id: "1")], forKey: "key1")
        await sut.set([makeAPODItem(id: "2")], forKey: "key1")
        
        let result = await sut.get(forKey: "key1")
        let id = await result?.first?.id
        XCTAssertEqual(id, "2")
    }
    
    func test_clear_emptiesStorage() async {
        let sut = QueryCache(ttl: 60)
        await sut.set([makeAPODItem(id: "1")], forKey: "key1")
        await sut.clear()
        
        let result = await sut.get(forKey: "key1")
        XCTAssertNil(result)
    }
}

private func makeAPODItem(id: String) -> APODItem {
    APODItem(id: id,
             title: "Test",
             explanation: "Explanation",
             imageURL: nil,
             hdImageURL: nil,
             mediaType: .image,
             copyright: nil,
             date: "2024-01-01",
             keywords: [])
}
