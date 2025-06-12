import Foundation

struct NewsResponseDTO: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]
}

extension ArticleDTO {
    func toDomain() -> Article? {
        guard let title = title,
              let url = url,
              !title.isEmpty,
              !url.isEmpty else { return nil }
        
        return Article(
            source: Source(
                id: source.id,
                name: source.name ?? ""
            ),
            author: author,
            title: title,
            description: description,
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt ?? "",
            content: content
        )
    }
}
