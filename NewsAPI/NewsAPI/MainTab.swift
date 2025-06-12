import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backBlue
        print("open view")
        setupTabBar()
    }
    
    func setupTabBar() {
        let dependencyContainer = DependencyContainer()
        
        let searchNav = UINavigationController()
        
        let coordinator = SearchCoordinator(navigationController: searchNav, dependencyContainer: dependencyContainer)
        
        let viewModel = dependencyContainer.makeSearchViewModel()

        let searchVC = SearchViewController(viewModel: viewModel, coordinator: coordinator)
        
        searchNav.viewControllers = [searchVC]
    
        let favoritesNav = UINavigationController()
        let savedCoordinator = SavedArticlesCoordinator(navigationController: favoritesNav)

        let savedViewModel = dependencyContainer.makeSavedArticlesViewModel()
        let favoritesVC = SavedArticlesViewController(viewModel: savedViewModel, coordinator: savedCoordinator)
        favoritesNav.viewControllers = [favoritesVC]

        searchNav.tabBarItem = UITabBarItem(
            title: "News",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Bookmarks",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
            
        )
        viewControllers = [searchNav, favoritesNav]

        setupTabBarAppearance()
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .darkBlue

        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = .textUnmarked
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.textUnmarked]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

}

