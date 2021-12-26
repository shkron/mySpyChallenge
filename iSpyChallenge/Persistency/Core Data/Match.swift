//
//  Match.swift
//  iSpyChallenge
//

import UIKit
import CoreData

class Match: NSManagedObject, ManagedObjectType {
    
    static var entityName = "Match"
    
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var photoHref: String
    @NSManaged var verified: Bool
    
    @NSManaged var challenge: Challenge
    @NSManaged var player: User
}
