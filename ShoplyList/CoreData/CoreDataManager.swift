//
//  CoreDataManager.swift
//  ShoplyList
//
//  Created on 02.02.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import CoreData
import Foundation

// MARK: - Core Data Manager
@MainActor
final class CoreDataManager {
    static let shared = CoreDataManager()

    // MARK: - Properties
    private let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Initialization
    private init() {
        persistentContainer = NSPersistentContainer(name: "ShoplyList")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data failed to load: \(error), \(error.userInfo)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    // MARK: - Save
    func save() throws {
        guard viewContext.hasChanges else { return }
        try viewContext.save()
    }

    // MARK: - Generic CRUD Operations
    func fetch<T: NSManagedObject>(
        _ entityType: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        fetchLimit: Int? = nil
    ) throws -> [T] {
        let request = T.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if let fetchLimit {
            request.fetchLimit = fetchLimit
        }
        return try viewContext.fetch(request) as? [T] ?? []
    }

    func delete(_ object: NSManagedObject) throws {
        viewContext.delete(object)
        try save()
    }

    func deleteAll<T: NSManagedObject>(_ entityType: T.Type) throws {
        let request = T.fetchRequest()
        let objects = try viewContext.fetch(request) as? [T] ?? []
        objects.forEach { viewContext.delete($0) }
        try save()
    }
}

// MARK: - Background Fetch Extension
extension CoreDataManager {
    func fetchInBackground<T: NSManagedObject>(
        _ entityType: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        fetchLimit: Int? = nil
    ) async throws -> [T]  {
        let backgroundContext = persistentContainer.newBackgroundContext()

        return try await backgroundContext.perform {
            let request = entityType.self.fetchRequest()
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            if let fetchLimit {
                request.fetchLimit = fetchLimit
            }

            return try backgroundContext.fetch(request) as? [T] ?? []
        }
    }
}
