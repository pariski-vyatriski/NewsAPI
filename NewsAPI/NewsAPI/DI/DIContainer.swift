import Foundation

class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    private lazy var networkService: NetworkServiceProtocol = NetworkService()
    
    private lazy var newsAPIService: NewsAPIServiceProtocol = NewsAPIService(
        networkService: networkService
    )
    
    private lazy var newsRepository: NewsRepositoryProtocol = NewsRepository(
        apiService: newsAPIService
    )
    
    private lazy var fetchNewsUseCase: FetchNewsUseCaseProtocol = FetchNewsUseCase(
        repository: newsRepository
    )
    
    private lazy var fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol = FetchTopHeadlinesUseCase(
        repository: newsRepository
    )
    
    @MainActor func makeNewsViewModel() -> NewsViewModel {
        return NewsViewModel(
            fetchNewsUseCase: fetchNewsUseCase,
            fetchTopHeadlinesUseCase: fetchTopHeadlinesUseCase
        )
    }
}
