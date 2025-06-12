import UIKit

class DependencyContainer: DependencyContainerProtocol {
    private lazy var networkService: NetworkServiceProtocol = NetworkService()
    private lazy var newsAPIService: NewsAPIServiceProtocol = NewsAPIService(networkService: networkService)
    private lazy var coreDataService: CoreDataServiceProtocol = CoreDataService()
    
    private lazy var newsRepository: NewsRepositoryProtocol = NewsRepository(apiService: newsAPIService)
    private lazy var savedArticlesRepository: SavedArticlesRepositoryProtocol = SavedArticlesRepository(coreDataService: coreDataService)
    
    private lazy var fetchNewsUseCase: FetchNewsUseCaseProtocol = FetchNewsUseCase(repository: newsRepository)
    private lazy var saveArticleUseCase: SaveArticleUseCaseProtocol = SaveArticleUseCase(repository: savedArticlesRepository)
    private lazy var deleteArticleUseCase: DeleteArticleUseCaseProtocol = DeleteArticleUseCase(repository: savedArticlesRepository)
    private lazy var checkArticleSavedUseCase: CheckArticleSavedUseCaseProtocol = CheckArticleSavedUseCase(repository: savedArticlesRepository)
    
    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel(fetchNewsUseCase: fetchNewsUseCase)
    }
    
    func makeArticleDetailViewModel(article: Article) -> ArticleDetailViewModel {
        return ArticleDetailViewModel(
            article: article,
            saveArticleUseCase: saveArticleUseCase,
            deleteArticleUseCase: deleteArticleUseCase,
            checkArticleSavedUseCase: checkArticleSavedUseCase
        )
    }
    
    func makeSavedArticlesViewModel() -> SavedArticlesViewModel {
        let service = CoreDataService()
        let repository = SavedArticlesRepository(coreDataService: service)
        let fetchUseCase = FetchSavedArticlesUseCase(repository: repository)
        let deleteUseCase = DeleteArticleUseCase(repository: repository)
        
        return SavedArticlesViewModel(fetchUseCase: fetchUseCase, deleteUseCase: deleteUseCase)
    }
    
    func makeSearchViewController() -> SearchViewController {
        let viewModel = makeSearchViewModel()
        let coordinator = SearchCoordinator(navigationController: UINavigationController(), dependencyContainer: self)
        return SearchViewController(viewModel: viewModel, coordinator: coordinator)
    }
}
