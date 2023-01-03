//
//  CDRating+CoreDataProperties.swift
//  iSpyChallenge
//

import Foundation
import CoreData

extension CDRating {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRating> {
        return NSFetchRequest<CDRating>(entityName: "CDRating")
    }

    @NSManaged public var id: String?
    @NSManaged public var stars: Int16
    @NSManaged public var creatorID: String?
}

extension CDRating : Identifiable {}
