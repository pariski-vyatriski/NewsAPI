import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let articleImageView = UIImageView()
    private let titleLabel = UILabel()
    private let sourceLabel = UILabel()
    private let dateLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let webView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let viewModel: ArticleDetailViewModel
    private var saveButton: UIBarButtonItem!
    
    private let stackView = UIStackView()
    private let infoContainer = UIView()
    
    init(viewModel: ArticleDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindViewModel()
        configureWithArticle()
        loadArticleContent()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        saveButton = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItems = [saveButton]

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(infoContainer)

        infoContainer.addSubview(articleImageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        infoContainer.addSubview(titleLabel)

        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        sourceLabel.textColor = .secondaryLabel
        infoContainer.addSubview(sourceLabel)

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        infoContainer.addSubview(dateLabel)


        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(webView)

        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            articleImageView.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            articleImageView.widthAnchor.constraint(equalToConstant: 100),
            articleImageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),

            sourceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            sourceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sourceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor),

            webView.heightAnchor.constraint(equalToConstant: 600),

            activityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),

            contentView.heightAnchor.constraint(equalTo: stackView.heightAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.isArticleSaved.bind { [weak self] isSaved in
            self?.updateSaveButton(isSaved: isSaved)
        }
        
        viewModel.toastMessage.bind { [weak self] message in
            guard let message = message else { return }
            self?.showToast(message: message)
        }
    }
    
    private func configureWithArticle() {
        let article = viewModel.getArticle()
        titleLabel.text = article.title
        sourceLabel.text = article.source.name
        descriptionLabel.text = article.description ?? "Description not available"
        dateLabel.text = viewModel.getFormattedDate()
        
        if let imageUrl = viewModel.getImageURL() {
            loadImage(from: imageUrl)
        } else {
            articleImageView.image = UIImage(systemName: "photo")
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.articleImageView.image = image
            }
        }.resume()
    }
    
    private func loadArticleContent() {
        guard let url = viewModel.getArticleURL() else { return }
        
        activityIndicator.startAnimating()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func updateSaveButton(isSaved: Bool) {
        saveButton.image = UIImage(systemName: isSaved ? "bookmark.fill" : "bookmark")
        saveButton.tintColor = isSaved ? .systemYellow : .textUnmarked
    }
    
    @objc private func saveButtonTapped() {
        viewModel.toggleSaveStatus()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let isSaved = CoreDataManager.shared.isArticleSaved(self.viewModel.getArticle())
            print("Checking the save:\(isSaved ? "successfully" : "failed")")
            self.updateSaveButton(isSaved: isSaved)
        }
    }
    
    private func showToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}

extension ArticleDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
