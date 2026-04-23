import XCTest
@testable import NASAExplorer

// MARK: - Mock

final class MockAPODRepository: APODRepository {
    
    var stubbedResult: Result<[APODItem], Error> = .success([])
    var fetchCallCount: Int = 0
    var lastQuery: String?
    
    func fetchItems(query: String) async throws -> [APODItem] {
        fetchCallCount += 1
        lastQuery = query
        
        switch stubbedResult {
            case .success(let items): return items
            case .failure(let error): throw error
        }
    }
}

// MARK: - Tests
final class SearchUseCaseTests: XCTestCase {
    
    private var sut: SearchAPODUseCase!
    private var mockRepository: MockAPODRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockAPODRepository()
        sut = SearchAPODUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success
    func test_execute_returnsItems_whenRepositorySucceeds() async throws {
        let expectedItems = [makeItem(id: "1", title: "Galaxy A"),
                             makeItem(id: "2", title: "Galaxy B")]
        
        mockRepository.stubbedResult = .success(expectedItems)
        
        let result = try await sut.execute(query: "galaxy")
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result, expectedItems)
    }
    
    // MARK: - Empty results
    func test_execute_returnsEmptyArray_whenRepositoryReturnsNoItems() async throws {
        mockRepository.stubbedResult = .success([])
        
        let result = try await sut.execute(query: "unknown")
        
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: - Error propagation
    func test_execute_throwsError_whenRepositoryFails() async throws {
        mockRepository.stubbedResult = .failure(APIError.invalidResponse)
        
        do {
            _ = try await sut.execute(query: "mars")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
    
    // MARK: - Query forwarding
    func test_execute_forwardsQueryToRepository() async throws {
        mockRepository.stubbedResult = .success([])
        
        _ = try await sut.execute(query: "nebula")
        
        XCTAssertEqual(mockRepository.lastQuery, "nebula")
        XCTAssertEqual(mockRepository.fetchCallCount, 1)
    }
}

// MARK: - Helpers
private func makeItem(id: String, title: String) -> APODItem {
    APODItem(id: id,
             title: title,
             explanation: "Test explanation",
             imageURL: nil,
             hdImageURL: nil,
             mediaType: .image,
             copyright: nil,
             date: "2024-01-01",
             keywords: [])
}
