import Foundation

protocol DependencyContainerProtocol {
    func makeSearchViewModel() -> SearchViewModel
    func makeArticleDetailViewModel(article: Article) -> ArticleDetailViewModel
    func makeSearchViewController() -> SearchViewController
}

protocol SearchCoordinatorProtocol {
    func showArticleDetail(article: Article)
}
