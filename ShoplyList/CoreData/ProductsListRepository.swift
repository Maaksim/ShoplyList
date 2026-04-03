//
//  ProductsListRepository.swift
//  ShoplyList
//
//  Created on 02.02.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import CoreData
import Foundation

@MainActor
protocol ProductsListRepositoryProtocol {
    func fetchAll() throws -> [ProductsListDTO]
    func fetch(byId id: Int) throws -> ProductsListDTO?
    func save(_ list: ProductsListDTO) throws
    func delete(_ list: ProductsListDTO) throws
    func addItem(_ item: ProductItemDTO, toListId listId: Int) throws
    func updateItem(_ item: ProductItemDTO, inListId listId: Int) throws
    func deleteItem(_ item: ProductItemDTO, fromListId listId: Int) throws
}

@MainActor
final class ProductsListRepository: ProductsListRepositoryProtocol {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }

    // MARK: - Fetch
    func fetchAll() throws -> [ProductsListDTO] {
        let sortDescriptor = NSSortDescriptor(key: "updatedDate", ascending: false)
        let entities: [ProductsListEntity] = try coreDataManager.fetch(
            ProductsListEntity.self,
            sortDescriptors: [sortDescriptor]
        )

        return entities.map { ProductsListDTO(entity: $0) }
    }

    func fetch(byId id: Int) throws -> ProductsListDTO? {
        let predicate = NSPredicate(format: "id == %d", id)
        let entities: [ProductsListEntity] = try coreDataManager.fetch(
            ProductsListEntity.self,
            predicate: predicate,
            fetchLimit: 1
        )
        return entities.first.map { ProductsListDTO(entity: $0) }
    }

    // MARK: - Save
    func save(_ list: ProductsListDTO) throws {
        let context = coreDataManager.viewContext

        // Check if entity already exists
        let predicate = NSPredicate(format: "id == %d", list.id)
        let existingEntities: [ProductsListEntity] = try coreDataManager.fetch(
            ProductsListEntity.self,
            predicate: predicate,
            fetchLimit: 1
        )

        let entity: ProductsListEntity
        if let existing = existingEntities.first {
            entity = existing
        } else {
            entity = ProductsListEntity(context: context)
        }

        entity.update(from: list, in: context)
        try coreDataManager.save()
    }

    // MARK: - Delete
    func delete(_ list: ProductsListDTO) throws {
        let predicate = NSPredicate(format: "id == %d", list.id)
        let entities: [ProductsListEntity] = try coreDataManager.fetch(
            ProductsListEntity.self,
            predicate: predicate,
            fetchLimit: 1
        )

        if let entity = entities.first {
            try coreDataManager.delete(entity)
        }
    }

    // MARK: - Item Operations
    func addItem(_ item: ProductItemDTO, toListId listId: Int) throws {
        guard var list = try fetch(byId: listId) else {
            throw RepositoryError.listNotFound
        }

        list.items.append(item)
        list.updatedDate = Date()
        try save(list)
    }

    func updateItem(_ item: ProductItemDTO, inListId listId: Int) throws {
        guard var list = try fetch(byId: listId) else {
            throw RepositoryError.listNotFound
        }

        if let index = list.items.firstIndex(where: { $0.id == item.id }) {
            list.items[index] = item
            list.updatedDate = Date()
            try save(list)
        }
    }

    func deleteItem(_ item: ProductItemDTO, fromListId listId: Int) throws {
        guard var list = try fetch(byId: listId) else {
            throw RepositoryError.listNotFound
        }

        list.items.removeAll { $0.id == item.id }
        list.updatedDate = Date()
        try save(list)
    }
}

// MARK: - Background Fetch Extension
extension ProductsListRepository {
    func fetchAllInBackground() async throws -> [ProductsListDTO] {
        let sortDescriptor = NSSortDescriptor(key: "updatedDate", ascending: false)

        let entities: [ProductsListEntity] = try await coreDataManager.fetchInBackground(
            ProductsListEntity.self,
            sortDescriptors: [sortDescriptor]
        )

        return entities.map { ProductsListDTO(entity: $0) }
    }
}

// MARK: - Errors
enum RepositoryError: LocalizedError {
    case listNotFound

    var errorDescription: String? {
        switch self {
        case .listNotFound:
            return "Products list not found"
        }
    }
}
