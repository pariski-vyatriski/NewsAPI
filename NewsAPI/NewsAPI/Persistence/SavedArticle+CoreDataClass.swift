//
//  SavedArticle+CoreDataClass.swift
//  NewsAPI
//
//  Created by Andrei Dzmitranok on 8.06.25.
//
//

import Foundation
import CoreData

@objc(SavedArticle)
public class SavedArticle: NSManagedObject {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.savedDate = Date()
    }
}
