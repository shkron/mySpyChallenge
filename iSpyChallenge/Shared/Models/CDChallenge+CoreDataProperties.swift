//
//  CDChallenge+CoreDataProperties.swift
//  iSpyChallenge
//

import Foundation
import CoreData

extension CDChallenge {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDChallenge> {
        return NSFetchRequest<CDChallenge>(entityName: "CDChallenge")
    }

    @NSManaged public var id: String?
    @NSManaged public var hint: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photoImageName: String?
    @NSManaged public var creatorID: String?
    @NSManaged public var distance: Double
    @NSManaged public var matches: Set<CDMatch>?
    @NSManaged public var ratings: Set<CDRating>?
    
    var allMatches: [CDMatch] {
        guard let allMatches = matches else {return []}
        return Array(allMatches)
    }
    
    var allRatings: [CDRating] {
        guard let allRatings = ratings else {return []}
        return Array(allRatings)
    }
}

// MARK: Generated accessors for matches
extension CDChallenge {

    @objc(addMatchesObject:)
    @NSManaged public func addToMatches(_ value: CDMatch)

    @objc(removeMatchesObject:)
    @NSManaged public func removeFromMatches(_ value: CDMatch)

    @objc(addMatches:)
    @NSManaged public func addToMatches(_ values: NSSet)

    @objc(removeMatches:)
    @NSManaged public func removeFromMatches(_ values: NSSet)

}

// MARK: Generated accessors for ratings
extension CDChallenge {

    @objc(addRatingsObject:)
    @NSManaged public func addToRatings(_ value: CDRating)

    @objc(removeRatingsObject:)
    @NSManaged public func removeFromRatings(_ value: CDRating)

    @objc(addRatings:)
    @NSManaged public func addToRatings(_ values: NSSet)

    @objc(removeRatings:)
    @NSManaged public func removeFromRatings(_ values: NSSet)

}

extension CDChallenge : Identifiable {}
