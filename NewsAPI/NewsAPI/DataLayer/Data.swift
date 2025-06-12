import Foundation

protocol SavedArticlesRepositoryProtocol {
    func fetchSavedArticles() -> [Article]
    func saveArticle(_ article: Article) -> Bool
    func deleteArticle(_ article: Article)
    func isArticleSaved(_ article: Article) -> Bool
}

final class SavedArticlesRepository: SavedArticlesRepositoryProtocol {
    private let coreDataService: CoreDataServiceProtocol

    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }

    func fetchSavedArticles() -> [Article] {
        return coreDataService.fetchSavedArticles()
    }

    func saveArticle(_ article: Article) -> Bool {
        return coreDataService.saveArticle(article)
    }

    func deleteArticle(_ article: Article) {
        coreDataService.deleteArticle(article)
    }

    func isArticleSaved(_ article: Article) -> Bool {
        return coreDataService.isArticleSaved(article)
    }
}

protocol CoreDataServiceProtocol {
    func saveArticle(_ article: Article) -> Bool
    func deleteArticle(_ article: Article)
    func isArticleSaved(_ article: Article) -> Bool
    func fetchSavedArticles() -> [Article]      
}
