import Foundation

protocol NetworkServiceProtocol {
    func request<T: Codable>(url: URL, responseType: T.Type) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    func request<T: Codable>(url: URL, responseType: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw NewsError.networkError
        }
        
        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch {
            throw NewsError.decodingError
        }
    }
}
