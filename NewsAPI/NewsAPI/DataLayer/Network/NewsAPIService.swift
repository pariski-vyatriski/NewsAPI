import Foundation

protocol NewsAPIServiceProtocol {
    func fetchNews(query: String) async throws -> NewsResponseDTO
    func fetchTopHeadlines(category: String?) async throws -> NewsResponseDTO
}

class NewsAPIService: NewsAPIServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let apiKey = "03a08255e08b4db780fc52935fef1462"
    private let baseURL = "https://newsapi.org/v2"
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchNews(query: String) async throws -> NewsResponseDTO {
        let url = try buildNewsURL(query: query)
        return try await networkService.request(url: url, responseType: NewsResponseDTO.self)
    }
    
    func fetchTopHeadlines(category: String?) async throws -> NewsResponseDTO {
        let url = try buildTopHeadlinesURL(category: category)
        return try await networkService.request(url: url, responseType: NewsResponseDTO.self)
    }
    
    private func buildNewsURL(query: String) throws -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today) ?? today
        
        let fromDate = dateFormatter.string(from: sevenDaysAgo)
        let toDate = dateFormatter.string(from: today)
        
        var urlComponents = URLComponents(string: "\(baseURL)/everything")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "from", value: fromDate),
            URLQueryItem(name: "to", value: toDate),
            URLQueryItem(name: "pageSize", value: "20"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "sortBy", value: "publishedAt"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            throw NewsError.invalidURL
        }
        
        return url
    }
    
    private func buildTopHeadlinesURL(category: String?) throws -> URL {
        var urlComponents = URLComponents(string: "\(baseURL)/top-headlines")!
        
        var queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "pageSize", value: "20"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw NewsError.invalidURL
        }
        
        return url
    }
}
