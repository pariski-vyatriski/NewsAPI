import Foundation

class NewsRepository: NewsRepositoryProtocol {
    private let apiService: NewsAPIServiceProtocol
    
    init(apiService: NewsAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchNews(query: String) async throws -> [Article] {
        let response = try await apiService.fetchNews(query: query)
        
        guard response.status == "ok" else {
            throw NewsError.apiError
        }
        
        return response.articles.compactMap { $0.toDomain() }
    }
    
    func fetchTopHeadlines(category: String?) async throws -> [Article] {
        let response = try await apiService.fetchTopHeadlines(category: category)
        
        guard response.status == "ok" else {
            throw NewsError.apiError
        }
        
        return response.articles.compactMap { $0.toDomain() }
    }
}
