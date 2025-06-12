import Foundation
import CoreData


extension SavedArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedArticle> {
        return NSFetchRequest<SavedArticle>(entityName: "SavedArticle")
    }

    @NSManaged public var title: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var savedDate: Date?

}

extension SavedArticle : Identifiable {

}
