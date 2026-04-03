//
//  ProductItem.swift
//  ShoplyList
//
//  Created on 02.02.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import Foundation

struct ProductItemDTO: Identifiable, Equatable, Sendable {
    let id: UUID
    var title: String
    var count: Int
    var price: Double
    var isCompleted: Bool

    init(
        id: UUID = UUID(),
        title: String,
        count: Int = 1,
        price: Double = 0.0,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.count = count
        self.price = price
        self.isCompleted = isCompleted
    }
}

// MARK: - Mapping
extension ProductItemDTO {
    init(entity: ProductItemEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? ""
        self.count = Int(entity.count)
        self.price = entity.price
        self.isCompleted = entity.isCompleted
    }
}
