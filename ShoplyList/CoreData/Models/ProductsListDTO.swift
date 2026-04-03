//
//  ProductsList.swift
//  ShoplyList
//
//  Created on 02.02.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import Foundation

struct ProductsListDTO: Identifiable, Equatable, Sendable {
    let id: Int
    var name: String
    var updatedDate: Date
    var items: [ProductItemDTO]

    init(
        id: Int,
        name: String,
        updatedDate: Date = Date(),
        items: [ProductItemDTO] = []
    ) {
        self.id = id
        self.name = name
        self.updatedDate = updatedDate
        self.items = items
    }
}

// MARK: - Mapping from Entity
extension ProductsListDTO {
    /// Creates a ProductsList from a Core Data entity.
    /// Must be called within the entity's context queue (e.g., inside context.perform).
    init(entity: ProductsListEntity) {
        self.id = Int(entity.id)
        self.name = entity.name ?? ""
        self.updatedDate = entity.updatedDate ?? Date()

        let itemEntities = entity.items?.allObjects as? [ProductItemEntity] ?? []
        self.items = itemEntities.map { ProductItemDTO(entity: $0) }
    }
}
