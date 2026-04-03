//
//  AllListsAssembly.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.

import SwiftUI

struct AllListsAssembly {
    func make(coordinator: ListsCoordinator) -> some View {
        let viewModel = AllListsViewModel(coordinator: coordinator)
        let view = AllListsView(viewModel: viewModel)
        return view
    }
}
