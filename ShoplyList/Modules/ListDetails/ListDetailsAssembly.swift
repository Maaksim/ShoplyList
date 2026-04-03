//
//  ListDetailsAssembly.swift
//  ShoplyList
//
//  Created on 12.02.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import SwiftUI

@MainActor
struct ListDetailsAssembly {
    func make(list: ProductsListDTO, coordinator: ListsCoordinator) -> some View {
        let viewModel = ListDetailsViewModel(
            list: list,
            coordinator: coordinator
        )
        return ListDetailsView(viewModel: viewModel)
    }
}
