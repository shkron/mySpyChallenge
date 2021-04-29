//
//  DataController.swift
//  iSpyChallenge
//

import CoreData

protocol DataControllerInjectable: AnyObject {
    var dataController: DataController { get set }
}

enum CoreDataStackError: Error {
    case invalidManagedObjectModuleName
    case unsupportedPersistentStoreType
}

class DataController: NSObject {
    
    private let moduleName: String
    private let storeType: String
    private let bundle: Bundle
    
    // MARK: - Initializer
    
    init(managedObjectModuleName: String, persistentStoreType: String, managedObjectModuleBundle: Bundle) throws {
        
        if managedObjectModuleBundle.url(forResource: managedObjectModuleName, withExtension: "momd") == nil {
            throw CoreDataStackError.invalidManagedObjectModuleName
        } else if persistentStoreType != NSInMemoryStoreType && persistentStoreType != NSSQLiteStoreType {
            throw CoreDataStackError.unsupportedPersistentStoreType
        }
        
        moduleName = managedObjectModuleName
        storeType = persistentStoreType
        bundle = managedObjectModuleBundle
        
        super.init()
    }
    
    // MARK: - Private State
    
    private lazy var applicationsDocumentsDirectory: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let url = bundle.url(forResource: moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: url)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        if storeType == NSInMemoryStoreType {
            do {
                try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            } catch {
                fatalError("NSInMemoryStoreType persistent store error: \(error)")
            }
        
        } else if storeType == NSSQLiteStoreType {
            do {
                let persistentStoreURL = applicationsDocumentsDirectory.appendingPathComponent("\(moduleName).sqlite")
                let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
                try coordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: persistentStoreURL, options: options)
            } catch {
                fatalError("NSSQLiteStoreType persistent store error: \(error)")
            }
        }
        
        return coordinator
    }()
    
    private lazy var persistenceManagedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = persistentStoreCoordinator
        return moc
    }()
    
    // MARK: - Managed Object Contexts
    
    lazy var mainQueueManagedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.parent = persistenceManagedObjectContext
        moc.name = "Main Queue Context"
        NotificationCenter.default.addObserver(self, selector: #selector(DataController.didSaveContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: moc)
        return moc
    }()
    
    // MARK: - Managed Object Context Did Save Event Handling
    
    @objc func didSaveContext(_ notification: NSNotification) {
        
        guard let moc = notification.object as? NSManagedObjectContext else {
            assertionFailure("Notification posted from an object other than an NSManagedObjectContext")
            return
        }
        
        guard  let parentContext = moc.parent else {
            return
        }
        
        parentContext.performAndWait {
            do {
                try parentContext.save()
            } catch {
                print("Data Controller = Error saving parent context")
            }
        }
    }
    
    // MARK: - Deallocation
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
