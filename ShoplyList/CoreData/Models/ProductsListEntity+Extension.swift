//
//  ProductsListEntity+Extension.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 03.02.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import CoreData

// MARK: - Mapping to Entity
extension ProductsListEntity {
    /// Updates the entity from a domain model.
    /// Must be called within the entity's context queue (e.g., inside context.perform).
    func update(from model: ProductsListDTO, in context: NSManagedObjectContext) {
        self.id = Int32(model.id)
        self.name = model.name
        self.updatedDate = model.updatedDate

        // Remove existing items
        if let existingItems = self.items as? Set<ProductItemEntity> {
            existingItems.forEach { context.delete($0) }
        }

        // Add new items
        let itemEntities = model.items.map { item -> ProductItemEntity in
            let entity = ProductItemEntity(context: context)
            entity.update(from: item)
            entity.list = self
            return entity
        }

        self.items = NSSet(array: itemEntities)
    }
}
