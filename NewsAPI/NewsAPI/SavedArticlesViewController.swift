import UIKit

class SavedArticlesViewController: UIViewController {
    private let tableView = UITableView()
    private var savedArticles: [SavedArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSavedArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedArticles()
    }
    
    private func setupUI() {
        title = "Saved"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadSavedArticles() {
        savedArticles = CoreDataManager.shared.fetchSavedArticles()
        tableView.reloadData()
        
        if savedArticles.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
    
    private func showEmptyState() {
        let emptyLabel = UILabel()
        emptyLabel.text = "No saved articles"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .systemGray
        emptyLabel.font = UIFont.systemFont(ofSize: 18)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        emptyLabel.tag = 999
    }
    
    private func hideEmptyState() {
        if let emptyLabel = view.viewWithTag(999) {
            emptyLabel.removeFromSuperview()
        }
    }
}

extension SavedArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        let savedArticle = savedArticles[indexPath.row]
        
        let article = CoreDataManager.shared.convertToArticle(savedArticle)
        cell.configure(with: article)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let savedArticle = savedArticles[indexPath.row]
        
        let article = CoreDataManager.shared.convertToArticle(savedArticle)
        
        let detailVC = ArticleDetailViewController(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let savedArticle = savedArticles[indexPath.row]
            let article = CoreDataManager.shared.convertToArticle(savedArticle)
            
            if CoreDataManager.shared.deleteArticle(article) {
                savedArticles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                if savedArticles.isEmpty {
                    showEmptyState()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
