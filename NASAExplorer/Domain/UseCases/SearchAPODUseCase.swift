import Foundation

protocol SearchAPODUseCaseProtocol {
    func execute(query: String) async throws -> [APODItem]
}

final class SearchAPODUseCase: SearchAPODUseCaseProtocol {
    private let repository: APODRepository
    
    init(repository: APODRepository) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [APODItem] {
        return try await repository.fetchItems(query: query)
    }
}
