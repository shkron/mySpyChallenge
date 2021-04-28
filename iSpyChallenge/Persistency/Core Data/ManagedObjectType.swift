//
//  ManagedObjectType.swift
//  iSpyChallenge
//

import CoreData

protocol ManagedObjectType: AnyObject {
    static var entityName: String { get }
}

extension ManagedObjectType {
    
    static func newFetchRequest<T: NSManagedObject>() -> NSFetchRequest<T> {
        NSFetchRequest<T>(entityName: entityName)
    }
}
