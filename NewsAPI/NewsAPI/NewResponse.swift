import UIKit

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

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

class NewsManager {
    static let shared = NewsManager()
    private let apiKey = "03a08255e08b4db780fc52935fef1462"
    private let baseURL = "https://newsapi.org/v2"
    
    private init() {}
    
    func fetchNews(query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
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
            completion(.failure(NewsError.invalidURL))
            return
        }
        
        print("Запрос к URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Сетевая ошибка: \(error)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP статус: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("Нет данных")
                completion(.failure(NewsError.noData))
                return
            }
            
            print("Получено данных: \(data.count) байт")
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON ответ: \(jsonString)")
            }
            
            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                print("Успешно декодировано. Статус: \(newsResponse.status), статей: \(newsResponse.articles.count ?? 0)")
 
                if newsResponse.status == "ok" {
                    completion(.success(newsResponse.articles ?? []))
                } else {

                }
            } catch {
                print("Ошибка декодирования: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchTopHeadlines(category: String? = nil, completion: @escaping (Result<[Article], Error>) -> Void) {
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
            completion(.failure(NewsError.invalidURL))
            return
        }
        
        print("Запрос к URL (топ новости): \(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NewsError.noData))
                return
            }
            
            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                if newsResponse.status == "ok" {
                    completion(.success(newsResponse.articles ?? []))
                } else {

                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum NewsError: LocalizedError {
    case invalidURL
    case noData
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .noData:
            return "Нет данных"
        case .apiError(let message):
            return "Ошибка API: \(message)"
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
