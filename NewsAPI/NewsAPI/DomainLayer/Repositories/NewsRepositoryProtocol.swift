import UIKit

protocol NewsRepositoryProtocol {
    func fetchNews(query: String) async throws -> [Article]
    func fetchTopHeadlines(category: String?) async throws -> [Article]
}

protocol FetchNewsUseCaseProtocol {
    func execute(query: String) async throws -> [Article]
}

protocol FetchTopHeadlinesUseCaseProtocol {
    func execute(category: String?) async throws -> [Article]
}
