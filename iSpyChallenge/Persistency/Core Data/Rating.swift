//
//  Rating.swift
//  iSpyChallenge
//

import UIKit
import CoreData

class Rating: NSManagedObject, ManagedObjectType {

    static var entityName = "Rating"
    
    @NSManaged var stars: Int
    
    @NSManaged var challenge: Challenge
    @NSManaged var player: User
}
