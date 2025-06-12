import UIKit

class ArticleDetailViewModel {
    private let article: Article
    private let saveArticleUseCase: SaveArticleUseCaseProtocol
    private let deleteArticleUseCase: DeleteArticleUseCaseProtocol
    private let checkArticleSavedUseCase: CheckArticleSavedUseCaseProtocol
    
    var isArticleSaved: Observable<Bool>
    var toastMessage: Observable<String?> = Observable(nil)
    
    init(article: Article,
         saveArticleUseCase: SaveArticleUseCaseProtocol,
         deleteArticleUseCase: DeleteArticleUseCaseProtocol,
         checkArticleSavedUseCase: CheckArticleSavedUseCaseProtocol) {
        self.article = article
        self.saveArticleUseCase = saveArticleUseCase
        self.deleteArticleUseCase = deleteArticleUseCase
        self.checkArticleSavedUseCase = checkArticleSavedUseCase
        
        self.isArticleSaved = Observable(checkArticleSavedUseCase.execute(article: article))
    }
    
    func getArticle() -> Article {
        return article
    }
    
    func toggleSaveStatus() {
        if isArticleSaved.value {
            deleteArticleUseCase.execute(article: article)
            isArticleSaved.value = false
            toastMessage.value = "The article has been removed from saved"
        } else {
            let success = saveArticleUseCase.execute(article: article)
            isArticleSaved.value = success
            toastMessage.value = success ? "Article saved" : "Failed to save article"
        }
    }
    
    func getFormattedDate() -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: article.publishedAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .long
            displayFormatter.timeStyle = .short
            displayFormatter.locale = Locale(identifier: "en_EN")
            return displayFormatter.string(from: date)
        }
        return ""
    }
    
    func getArticleURL() -> URL? {
        return URL(string: article.url)
    }
    
    func getImageURL() -> URL? {
        guard let imageUrl = article.urlToImage else { return nil }
        return URL(string: imageUrl)
    }
}

