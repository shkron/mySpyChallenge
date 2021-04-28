//
//  Challenge.swift
//  iSpyChallenge
//

import UIKit
import CoreData

class Challenge: NSManagedObject, ManagedObjectType {

    static var entityName = "Challenge"
    
    @NSManaged var hint: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: String
    @NSManaged var photoHref: Double
    
    @NSManaged var creator: User
    @NSManaged var matches: Set<Match>
    @NSManaged var ratings: Set<Rating>
}
