//
//  CDUser+CoreDataProperties.swift
//  iSpyChallenge
//

import Foundation
import CoreData

extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var id: String?
    @NSManaged public var email: String?
    @NSManaged public var username: String?
    @NSManaged public var challenges: Set<CDChallenge>?
    
    var allChallenges: [CDChallenge] {
        guard let allChallenges = challenges else {return []}
        return Array(allChallenges)
    }
}

// MARK: Generated accessors for challenges
extension CDUser {

    @objc(addChallengesObject:)
    @NSManaged public func addToChallenges(_ value: CDChallenge)

    @objc(removeChallengesObject:)
    @NSManaged public func removeFromChallenges(_ value: CDChallenge)

    @objc(addChallenges:)
    @NSManaged public func addToChallenges(_ values: NSSet)

    @objc(removeChallenges:)
    @NSManaged public func removeFromChallenges(_ values: NSSet)

}

extension CDUser : Identifiable {}
