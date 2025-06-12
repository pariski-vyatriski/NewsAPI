import UIKit

struct NewsCellViewModel {
    let title: String
    let source: String
    let description: String
    let date: String
    let imageURL: URL?

    init(article: Article) {
        self.title = article.title
        self.source = article.source.name
        self.description = article.description ?? "Description not available"

        if let date = ISO8601DateFormatter().date(from: article.publishedAt) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier: "en_EN")
            self.date = formatter.string(from: date)
        } else {
            self.date = ""
        }

        self.imageURL = URL(string: article.urlToImage ?? "")
    }
}
