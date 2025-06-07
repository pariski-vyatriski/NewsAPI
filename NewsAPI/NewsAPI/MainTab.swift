import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backBlue
        print("open view")
        setupTabBar()
    }
    
    func setupTabBar() {

        let searchVC = SearchViewController()
        let favoritesVC = SavedArticlesViewController()
        
        let searchNav = UINavigationController(rootViewController: searchVC)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        
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
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
        tabBar.barTintColor = .darkBlue
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .darkBlue
            appearance.shadowColor = .systemGray4
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

