import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveArticle(_ article: Article) -> Bool {
        if isArticleSaved(article) {
            return false
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "SavedArticle", in: context) else {
            print("Не удалось найти entity SavedArticle")
            return false
        }
        
        let savedArticle = SavedArticle(entity: entity, insertInto: context)
        
        savedArticle.title = article.title
        savedArticle.articleDescription = article.description
        savedArticle.url = article.url
        savedArticle.urlToImage = article.urlToImage
        savedArticle.publishedAt = article.publishedAt
        savedArticle.sourceName = article.source.name
        savedArticle.savedDate = Date()
        
        do {
            try context.save()
            print("Article saved!")
            return true
        } catch {
            print("Saving error: \(error)")
            return false
        }
    }
    
    func deleteArticle(_ article: Article) -> Bool {
        let request: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", article.url ?? "")
        
        do {
            let savedArticles = try context.fetch(request)
            for savedArticle in savedArticles {
                context.delete(savedArticle)
            }
            try context.save()
            print("Статья удалена!")
            return true
        } catch {
            print("Ошибка удаления: \(error)")
            return false
        }
    }
    
    func isArticleSaved(_ article: Article) -> Bool {
        let request: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", article.url ?? "")
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Ошибка проверки: \(error)")
            return false
        }
    }
    
    func fetchSavedArticles() -> [SavedArticle] {
        let request: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "savedDate", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка загрузки: \(error)")
            return []
        }
    }
    
    func convertToArticle(_ savedArticle: SavedArticle) -> Article {
        let source = Source(id: nil, name: savedArticle.sourceName ?? "")
        
        return Article(
            source: source,
            author: nil,
            title: savedArticle.title ?? "",
            description: savedArticle.articleDescription,
            url: savedArticle.url ?? "",
            urlToImage: savedArticle.urlToImage,
            publishedAt: savedArticle.publishedAt ?? "",
            content: nil
        )
    }
}
