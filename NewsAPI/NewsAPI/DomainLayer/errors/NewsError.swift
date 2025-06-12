import Foundation

enum NewsError: Error, LocalizedError {
    case invalidURL
    case noData
    case networkError
    case decodingError
    case apiError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .networkError:
            return "Network error occurred"
        case .decodingError:
            return "Failed to decode response"
        case .apiError:
            return "API returned an error"
        }
    }
}

enum CoreDataError: Error, LocalizedError {
    case saveError
    case fetchError
    case deleteError
    
    var errorDescription: String? {
        switch self {
        case .saveError:
            return "Failed to save data"
        case .fetchError:
            return "Failed to fetch data"
        case .deleteError:
            return "Failed to delete data"
        }
    }
}
