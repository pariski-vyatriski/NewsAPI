import UIKit

protocol FetchSavedArticlesUseCaseProtocol {
    func execute() -> [Article]
}

final class FetchSavedArticlesUseCase: FetchSavedArticlesUseCaseProtocol {
    private let repository: SavedArticlesRepositoryProtocol
    init(repository: SavedArticlesRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> [Article] {
        return repository.fetchSavedArticles()
    }
}
