//
//  ProductItemEntity+Extension.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 03.02.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

extension ProductItemEntity {
    func update(from model: ProductItemDTO) {
        self.id = model.id
        self.title = model.title
        self.count = Int32(model.count)
        self.price = model.price
        self.isCompleted = model.isCompleted
    }
}
