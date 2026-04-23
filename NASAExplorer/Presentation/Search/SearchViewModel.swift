import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    
    // MARK: - Public
    @Published var query: String = ""
    @Published var items: [APODItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Private
    private let useCase: SearchAPODUseCaseProtocol
    private var searchTask: Task<Void, Never>?
    
    init(useCase: SearchAPODUseCaseProtocol? = nil) {
        self.useCase = useCase ?? SearchAPODUseCase(repository: APODRepositoryImpl())
    }
    
    func search() {
        searchTask?.cancel()
        
        let currentQuery = query.trimmingCharacters(in: .whitespaces)
        
        searchTask = Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let results = try await useCase.execute(query: currentQuery)
                
                guard !Task.isCancelled else { return }
                
                items = results
            } catch is CancellationError {
                // Expected when a new search cancels the previous task — no error shown to user
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = error.localizedDescription
                items = []
            }
            
            isLoading = false
        }
    }
    
    func clearSearch() {
        searchTask?.cancel()
        items = []
        errorMessage = nil
        isLoading = false
    }
}
