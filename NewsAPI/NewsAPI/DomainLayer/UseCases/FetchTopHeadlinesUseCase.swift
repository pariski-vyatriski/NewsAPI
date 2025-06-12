import UIKit

class FetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol {
    private let repository: NewsRepositoryProtocol
    
    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(category: String? = nil) async throws -> [Article] {
        return try await repository.fetchTopHeadlines(category: category)
    }
}
