//
//  CoreDataManager.swift
//  iSpyChallenge
//

import CoreData
import UIKit
import CoreLocation

class CoreDataManager {
    
    static let shared = CoreDataManager()

    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iSpyChallenges")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            if let error = error as NSError? {
                fatalError("Error loading persistentStores \(error)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving context \(nserror)")
            }
        }
    }
    
    // For Challenges that were created locally we need to update them 
    func updateChallengeDistancesInsidePersistentStore() {
        for challenge in allChallenges() {
            let newDistance = LocationManager.shared.getDistance(from: CLLocation(latitude: challenge.latitude, longitude: challenge.longitude))
            guard challenge.distance != newDistance else {return}
            challenge.distance = newDistance
            saveContext()
        }
    }
    
    func insert(users: [User]) {
        updateChallengeDistancesInsidePersistentStore()
        
        for user in users {
            _ = self.insert(user: user)
        }
    }
    
    // Starting with the User as the top most Object
    
    func insert(user: User) -> CDUser {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let newUser = CDUser(context: managedContext)
        newUser.id = user.id
        newUser.email = user.email
        newUser.username = user.username
        for challenge in user.challenges {
            let cdChallenge = CDChallenge(context: managedContext)
            cdChallenge.id = challenge.id
            cdChallenge.hint = challenge.hint
            cdChallenge.photoImageName = challenge.photoImageName
            cdChallenge.latitude = challenge.latitude
            cdChallenge.longitude = challenge.longitude
            cdChallenge.creatorID = challenge.creatorID
            cdChallenge.distance = LocationManager.shared.getDistance(from: challenge.getLocation())
            
            for match in challenge.matches {
                let newMatch = CDMatch(context: managedContext)
                newMatch.id = match.id
                newMatch.latitude = match.latitude
                newMatch.longitude = match.longitude
                newMatch.verified = match.verified
                newMatch.creatorID = match.creatorID
                cdChallenge.addToMatches(newMatch)
            }
            
            for rating in challenge.ratings {
                let newRating = CDRating(context: managedContext)
                newRating.id = rating.id
                newRating.stars = Int16(rating.stars)
                newRating.creatorID = rating.creatorID
                cdChallenge.addToRatings(newRating)
            }
            
            newUser.addToChallenges(cdChallenge)
        }
        saveContext()
        return newUser
    }
    
    func allUsers() -> [CDUser] {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CDUser>(entityName: "CDUser")
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch allUsers. \(error)")
        }
        return []
    }
    
    func allChallenges() -> [CDChallenge] {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CDChallenge>(entityName: "CDChallenge")
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch allChallenges. \(error)")
        }
        return []
    }
        
    lazy var fetchedResultsController: NSFetchedResultsController<CDChallenge> = {
        
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CDChallenge>(entityName: "CDChallenge")
        
        // Add Sort Descriptor to FetchRequest
        let sortDescriptor = NSSortDescriptor(key: "distance", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController<CDChallenge>(
                                        fetchRequest: fetchRequest,
                                        managedObjectContext: managedContext,
                                        sectionNameKeyPath: nil,
                                        cacheName: nil
                                       )

        return fetchedResultsController
    }()
}

// Mark: - Helper functions

extension CoreDataManager {
    
    func getUsername(by creatorID: String?) -> String {
        allUsers().filter({ $0.id == (creatorID ?? "") }).first?.username ?? ""
    }
    
    func matches(createdBy userId: String) -> [CDMatch] {
        allChallenges()
        .flatMap { $0.allMatches }
        .filter { $0.creatorID == userId }
    }
    
    func ratings(createdBy userId: String) -> [CDRating] {
        allChallenges()
        .flatMap { $0.allRatings }
        .filter { $0.creatorID == userId }
    }
}
