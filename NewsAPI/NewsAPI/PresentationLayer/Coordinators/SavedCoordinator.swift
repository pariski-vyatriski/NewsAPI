import UIKit

protocol SavedArticlesCoordinatorProtocol {
    func showArticleDetail(article: Article)
}

class SavedArticlesCoordinator: SavedArticlesCoordinatorProtocol {
    private let navController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navController = navigationController
    }

    func showArticleDetail(article: Article) {
        let viewModel = DependencyContainer().makeArticleDetailViewModel(article: article)
        let vc = ArticleDetailViewController(viewModel: viewModel)
        navController.pushViewController(vc, animated: true)
    }
}
