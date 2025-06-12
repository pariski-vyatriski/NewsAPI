import Foundation
@testable import NewsAPI
class NetworkServiceMock: NetworkServiceProtocol {
    var resultToReturn: Result<Data, Error>?
    
    func request<T>(url: URL, responseType: T.Type) async throws -> T where T : Decodable {
        if let result = resultToReturn {
            switch result {
            case .success(let data):
                let decoded = try JSONDecoder().decode(responseType, from: data)
                return decoded
            case .failure(let error):
                throw error
            }
        } else {
            fatalError("resultToReturn not set")
        }
    }
}

