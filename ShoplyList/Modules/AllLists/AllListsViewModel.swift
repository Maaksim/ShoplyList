//
//  AllListsViewModel.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.

import Foundation

@Observable
@MainActor
final class AllListsViewModel {
    // MARK: - Properties
    private(set) var lists: [ProductsListDTO] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let coordinator: ListsCoordinator
    private let repository: ProductsListRepository

    // MARK: - Initialization

    init(
        coordinator: ListsCoordinator,
        repository: ProductsListRepository = ProductsListRepository()
    ) {
        self.coordinator = coordinator
        self.repository = repository
    }

    // MARK: - Actions
    func onAppear() {
        fetchLists()
    }

    func fetchLists() {
        isLoading = true
        errorMessage = nil

        do {
            lists = try repository.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func showAddListSheet() {
        coordinator.presentAddListSheet { [weak self] name in
            self?.createNewList(name: name)
        }
    }

    func createNewList(name: String) {
        let newList = ProductsListDTO(
            id: Int.random(in: 1...100000),
            name: name,
            updatedDate: Date(),
            items: []
        )

        do {
            try repository.save(newList)
            fetchLists()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteList(_ list: ProductsListDTO) {
        do {
            try repository.delete(list)
            fetchLists()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func selectList(_ list: ProductsListDTO) {
        coordinator.pushListDetails(list: list)
    }
}
