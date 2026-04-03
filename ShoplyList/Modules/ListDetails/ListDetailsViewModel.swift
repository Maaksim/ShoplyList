//
//  ListDetailsViewModel.swift
//  ShoplyList
//
//  Created on 12.02.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import Coordinator
import Foundation

@Observable
@MainActor
final class ListDetailsViewModel {
    // MARK: - Properties
    private(set) var list: ProductsListDTO
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let coordinator: ListsCoordinator
    private let repository: ProductsListRepository

    var activeItems: [ProductItemDTO] {
        list.items.filter { !$0.isCompleted }
    }

    var completedItems: [ProductItemDTO] {
        list.items.filter { $0.isCompleted }
    }

    var completedCountText: String {
        LocalizationConstants.ListDetails.completedCount(
            completedItems.count,
            total: list.items.count
        )
    }

    var totalPrice: Double {
        list.items.reduce(0) { $0 + ($1.price * Double($1.count)) }
    }

    var formattedTotalPrice: String {
        String(format: "$%.2f", totalPrice)
    }

    // MARK: - Initialization
    init(
        list: ProductsListDTO,
        coordinator: ListsCoordinator,
        repository: ProductsListRepository = ProductsListRepository()
    ) {
        self.list = list
        self.coordinator = coordinator
        self.repository = repository
    }

    // MARK: - Actions
    func onAppear() {
        refreshList()
    }

    func refreshList() {
        do {
            if let updatedList = try repository.fetch(byId: list.id) {
                list = updatedList
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func goBack() {
        coordinator.popLast()
    }

    // MARK: - Item Actions
    func showProductPicker() {
        coordinator.presentProductPicker { [weak self] names in
            guard let self else { return }
            for name in names {
                self.addItem(ProductItemDTO(title: name))
            }
        }
    }

    func showEditItemSheet(item: ProductItemDTO) {
        coordinator.presentAddEditItemSheet(editingItem: item) { [weak self] updatedItem in
            self?.updateItem(updatedItem)
        }
    }

    func toggleItemCompleted(_ item: ProductItemDTO) {
        var updatedItem = item
        updatedItem.isCompleted.toggle()
        updateItem(updatedItem)
    }

    func deleteItem(_ item: ProductItemDTO) {
        do {
            try repository.deleteItem(item, fromListId: list.id)
            refreshList()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Private Methods
    private func addItem(_ item: ProductItemDTO) {
        do {
            try repository.addItem(item, toListId: list.id)
            refreshList()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func updateItem(_ item: ProductItemDTO) {
        do {
            try repository.updateItem(item, inListId: list.id)
            refreshList()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
