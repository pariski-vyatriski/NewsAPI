import Foundation

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String
}

protocol SaveArticleUseCaseProtocol {
    func execute(article: Article) -> Bool
}

protocol DeleteArticleUseCaseProtocol {
    func execute(article: Article)
}

protocol CheckArticleSavedUseCaseProtocol {
    func execute(article: Article) -> Bool
}

class SaveArticleUseCase: SaveArticleUseCaseProtocol {
    private let repository: SavedArticlesRepositoryProtocol
    
    init(repository: SavedArticlesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(article: Article) -> Bool {
        return repository.saveArticle(article)
    }
}

class DeleteArticleUseCase: DeleteArticleUseCaseProtocol {
    private let repository: SavedArticlesRepositoryProtocol
    
    init(repository: SavedArticlesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(article: Article) {
        repository.deleteArticle(article)
    }
}

class CheckArticleSavedUseCase: CheckArticleSavedUseCaseProtocol {
    private let repository: SavedArticlesRepositoryProtocol
    
    init(repository: SavedArticlesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(article: Article) -> Bool {
        return repository.isArticleSaved(article)
    }
}
