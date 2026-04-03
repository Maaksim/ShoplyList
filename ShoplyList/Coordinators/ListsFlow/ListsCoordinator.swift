//
//  ListsCoordinator.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//

import SwiftUI
import Coordinator

@Observable
final class ListsCoordinator: @MainActor FlowCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?

    var childCoordinator: (any Coordinator)?
    var navigationControllers = [NavigationController<ListsFlowRoute>]()

    init() {
        setupInitialNavigationController()
    }

    func destination(for route: ListsFlowRoute) -> some View {
        switch route {
        case .addList(let onCreate):
            AddListSheetView(onCreate: onCreate, onDismiss: { [weak self] in
                self?.dismissTop()
            })
        case .listDetails(let list):
            ListDetailsAssembly().make(list: list, coordinator: self)
        case .addEditItem(let editingItem, let onSave):
            AddEditItemSheetView(
                editingItem: editingItem,
                onSave: onSave,
                onDismiss: { [weak self] in
                    self?.dismissTop()
                }
            )
        case .productPicker(let onSelect):
            ProductPickerAssembly().make(coordinator: self, onSelect: onSelect)
        }
    }

    var rootView: some View {
        NavigatingView(
            nc: self.rootNavigationController,
            coordinator: self
        ) {
            AllListsAssembly().make(coordinator: self)
        }
    }

    func presentAddListSheet(onCreate: @escaping @MainActor (String) -> Void) {
        present(route: .addList(onCreate: onCreate))
    }

    func pushListDetails(list: ProductsListDTO) {
        push(route: .listDetails(list: list))
    }

    func presentAddEditItemSheet(
        editingItem: ProductItemDTO?,
        onSave: @escaping @MainActor (ProductItemDTO) -> Void
    ) {
        present(route: .addEditItem(editingItem: editingItem, onSave: onSave))
    }

    func presentProductPicker(onSelect: @escaping @MainActor ([String]) -> Void) {
        present(route: .productPicker(onSelect: onSelect))
    }

    deinit {
        print("Deinit FirstTabCoordinator")
    }
}
