import UIKit

class SearchCoordinator: SearchCoordinatorProtocol {
    private weak var navigationController: UINavigationController?
    private let dependencyContainer: DependencyContainerProtocol
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func showArticleDetail(article: Article) {
        let viewModel = dependencyContainer.makeArticleDetailViewModel(article: article)
        let detailVC = ArticleDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
