import Foundation

class SavedArticlesViewModel {
    @Published private(set) var savedArticles: [Article] = []
    private let fetchUseCase: FetchSavedArticlesUseCaseProtocol
    private let deleteUseCase: DeleteArticleUseCaseProtocol

    init(fetchUseCase: FetchSavedArticlesUseCaseProtocol, deleteUseCase: DeleteArticleUseCaseProtocol) {
        self.fetchUseCase = fetchUseCase
        self.deleteUseCase = deleteUseCase
    }

    func loadArticles() {
        savedArticles = fetchUseCase.execute()
    }

    func deleteArticle(at index: Int) {
        let article = savedArticles[index]
        deleteUseCase.execute(article: article)
        savedArticles.remove(at: index)
        
    }

    func article(at index: Int) -> Article {
        return savedArticles[index]
    }

    var isEmpty: Bool {
        savedArticles.isEmpty
    }
}
