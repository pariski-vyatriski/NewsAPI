import UIKit

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let fetchNewsUseCase: FetchNewsUseCaseProtocol
    private let fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol
    
    init(
        fetchNewsUseCase: FetchNewsUseCaseProtocol,
        fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol
    ) {
        self.fetchNewsUseCase = fetchNewsUseCase
        self.fetchTopHeadlinesUseCase = fetchTopHeadlinesUseCase
    }
    
    func searchNews(query: String) {
        Task {
            await performSearch(query: query)
        }
    }
    
    func loadTopHeadlines(category: String? = nil) {
        Task {
            await performLoadTopHeadlines(category: category)
        }
    }
    
    private func performSearch(query: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let articles = try await fetchNewsUseCase.execute(query: query)
            self.articles = articles
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func performLoadTopHeadlines(category: String?) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let articles = try await fetchTopHeadlinesUseCase.execute(category: category)
            self.articles = articles
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
