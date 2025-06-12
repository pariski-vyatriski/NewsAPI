import UIKit

class NewsTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let sourceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let newsImageView = UIImageView()
    private var imageTask: URLSessionDataTask?
    private var currentImageURL: URL?
    private let placeholderImage = UIImage(systemName: "photo")
    private var isInitialized = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeCell()
    }
    
    private func initializeCell() {
        guard !isInitialized else { return }
        
        if Thread.isMainThread {
            setupUI()
            setupConstraints()
            isInitialized = true
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.setupUI()
                self?.setupConstraints()
                self?.isInitialized = true
            }
        }
    }
    
    private func setupUI() {
        assert(Thread.isMainThread, "UI setup must be on main thread")
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        
        sourceLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        sourceLabel.textColor = .secondaryLabel
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 3
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 8
        newsImageView.backgroundColor = .white
        newsImageView.image = placeholderImage
        newsImageView.tintColor = .backBlue
        
        [titleLabel, sourceLabel, descriptionLabel, dateLabel, newsImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        assert(Thread.isMainThread, "Constraints must be set on main thread")
        
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            newsImageView.widthAnchor.constraint(equalToConstant: 80),
            newsImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            sourceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sourceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            sourceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 4),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 104)
        ])
    }
    
    func configure(with viewModel: NewsCellViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.updateContent(with: viewModel)
        }
    }
    
    private func updateContent(with viewModel: NewsCellViewModel) {
        titleLabel.text = viewModel.title
        sourceLabel.text = viewModel.source
        dateLabel.text = viewModel.date
        descriptionLabel.text = viewModel.description
        
        loadImageIfNeeded(from: viewModel.imageURL)
    }
    
    private func loadImageIfNeeded(from url: URL?) {
        guard currentImageURL != url else { return }
        
        imageTask?.cancel()
        currentImageURL = url
        
        newsImageView.image = placeholderImage
        
        guard let url = url else { return }
        
        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error as? URLError, error.code == .cancelled {
                return
            }
            
            let image = data.flatMap { UIImage(data: $0) } ?? self?.placeholderImage
            
            DispatchQueue.main.async {
                guard self?.currentImageURL == url else { return }
                self?.newsImageView.image = image
            }
        }
        
        imageTask?.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageTask?.cancel()
        imageTask = nil
        currentImageURL = nil
        
        DispatchQueue.main.async { [weak self] in
            self?.resetContent()
        }
    }
    
    private func resetContent() {
        newsImageView.image = placeholderImage
        titleLabel.text = nil
        sourceLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }
}
