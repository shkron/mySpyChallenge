//
//  CDMatch+CoreDataProperties.swift
//  iSpyChallenge
//

import Foundation
import CoreData

extension CDMatch {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMatch> {
            return NSFetchRequest<CDMatch>(entityName: "CDMatch")
    }

    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photoImageName: String?
    @NSManaged public var verified: Bool
    @NSManaged public var creatorID: String?
}

extension CDMatch : Identifiable {}
