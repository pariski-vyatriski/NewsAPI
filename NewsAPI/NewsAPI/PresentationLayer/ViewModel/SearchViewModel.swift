import UIKit

class SearchViewModel {
    private let fetchNewsUseCase: FetchNewsUseCaseProtocol
    
    var articles: Observable<[Article]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var error: Observable<String?> = Observable(nil)
    var selectedCategoryIndex: Observable<Int> = Observable(0)
    
    private let categories = [
        ("All", ""),
        ("Technology", "technology"),
        ("Politics", "politics"),
        ("Sport", "sports")
    ]
    
    init(fetchNewsUseCase: FetchNewsUseCaseProtocol) {
        self.fetchNewsUseCase = fetchNewsUseCase
    }
    
    func loadDefaultNews() {
        searchNews(query: "news")
    }
    
    func searchNews(query: String) {
        Task {
            await performSearch(query: query)
        }
    }

    private func performSearch(query: String) async {
        isLoading.value = true
        error.value = nil
        
        do {
            let fetchedArticles = try await fetchNewsUseCase.execute(query: query)
            articles.value = fetchedArticles
        } catch {
            self.error.value = error.localizedDescription
        }
        
        isLoading.value = false
    }
    
    func selectCategory(at index: Int) {
        selectedCategoryIndex.value = index
        let query = categories[index].1
        if query.isEmpty {
            loadDefaultNews()
        } else {
            searchNews(query: query)
        }
    }
    
    func getCategoriesCount() -> Int {
        return categories.count
    }
    
    func getCategory(at index: Int) -> (String, String) {
        return categories[index]
    }
    
    func getArticle(at index: Int) -> Article {
        return articles.value[index]
    }
}

