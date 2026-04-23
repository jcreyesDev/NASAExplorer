import Foundation

protocol APODRepository {
    func fetchItems(query: String) async throws -> [APODItem]
}
