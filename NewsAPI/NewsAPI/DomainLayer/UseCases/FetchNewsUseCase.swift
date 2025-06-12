import UIKit

class FetchNewsUseCase: FetchNewsUseCaseProtocol {
    private let repository: NewsRepositoryProtocol
    
    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [Article] {
        return try await repository.fetchNews(query: query)
    }
}
