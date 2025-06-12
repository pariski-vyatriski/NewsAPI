import Foundation
import CoreData

@objc(SavedArticle)
public class SavedArticle: NSManagedObject {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.savedDate = Date()
    }
}
