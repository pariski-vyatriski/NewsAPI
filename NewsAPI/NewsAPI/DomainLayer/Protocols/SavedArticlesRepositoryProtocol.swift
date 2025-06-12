import Foundation

class CoreDataService: CoreDataServiceProtocol {
    
    private let coreDataManager = CoreDataManager.shared
    
    func fetchSavedArticles() -> [Article] {
        let savedArticles: [SavedArticle] = coreDataManager.fetchSavedArticles()
        let dateFormatter = ISO8601DateFormatter()
        
        return savedArticles.map { savedArticle in
            let publishedAtString: String
            if let dateString = savedArticle.publishedAt,
               let date = dateFormatter.date(from: dateString) {
                publishedAtString = dateFormatter.string(from: date)
            } else {
                publishedAtString = ""
            }

            
            let source = Source(
                id: nil,
                name: savedArticle.sourceName ?? ""
            )
            
            return Article(
                source: source,
                author: nil,
                title: savedArticle.title ?? "",
                description: savedArticle.articleDescription ?? "",
                url: savedArticle.url ?? "",
                urlToImage: savedArticle.urlToImage,
                publishedAt: publishedAtString,
                content: nil
            )
        }
    }

    func saveArticle(_ article: Article) -> Bool {
        return coreDataManager.saveArticle(article)
    }
    
    func deleteArticle(_ article: Article) {
        _ = coreDataManager.deleteArticle(article)
    }
    
    func isArticleSaved(_ article: Article) -> Bool {
        return coreDataManager.isArticleSaved(article)
    }
}
