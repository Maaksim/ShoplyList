//
//  ProductPickerAssembly.swift
//  ShoplyList
//
//  Created on 03.04.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import SwiftUI

struct ProductPickerAssembly {
    func make(
        coordinator: ListsCoordinator,
        onSelect: @escaping @MainActor ([String]) -> Void
    ) -> some View {
        let viewModel = ProductPickerViewModel(coordinator: coordinator, onSelect: onSelect)
        return ProductPickerView(viewModel: viewModel)
    }
}
