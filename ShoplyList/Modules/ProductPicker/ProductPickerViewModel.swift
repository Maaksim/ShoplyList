//
//  ProductPickerViewModel.swift
//  ShoplyList
//
//  Created on 03.04.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import Foundation
import Coordinator

@Observable
@MainActor
final class ProductPickerViewModel {
    // MARK: - Tab
    enum Tab: CaseIterable {
        case popular, recent

        var title: String {
            switch self {
            case .popular: return LocalizationConstants.ProductPicker.popular
            case .recent: return LocalizationConstants.ProductPicker.recent
            }
        }
    }

    // MARK: - Properties
    var searchText = ""
    var selectedTab: Tab = .popular
    private(set) var selectedProductNames: Set<String> = []

    private let coordinator: ListsCoordinator
    let onSelect: @MainActor ([String]) -> Void

    // MARK: - Hardcoded Data
    private static let popularProducts: [String] = [
        "Milk", "Bread", "Eggs", "Butter", "Cheese",
        "Chicken", "Lettuce", "Toothpaste", "Juice", "Shampoo",
        "Water", "Ketchup", "Pasta", "Rice", "Potatoes",
        "Carrots", "Onion", "Tomatoes", "Bananas", "Apples",
        "Yogurt", "Coffee", "Tea", "Sugar", "Salt",
        "Flour", "Olive Oil", "Detergent", "Soap", "Paper Towels"
    ]

    private static let recentProducts: [String] = [
        "Milk", "Bread", "Eggs", "Cheese", "Water",
        "Bananas", "Potatoes", "Ketchup"
    ]

    // MARK: - Initialization
    init(coordinator: ListsCoordinator, onSelect: @escaping @MainActor ([String]) -> Void) {
        self.coordinator = coordinator
        self.onSelect = onSelect
    }

    // MARK: - Computed
    var currentProducts: [String] {
        selectedTab == .popular ? Self.popularProducts : Self.recentProducts
    }

    var filteredProducts: [String] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return currentProducts }
        return currentProducts.filter { $0.localizedCaseInsensitiveContains(trimmed) }
    }

    var customProductName: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var showCustomAddRow: Bool {
        let trimmed = customProductName
        guard !trimmed.isEmpty else { return false }
        return !currentProducts.contains(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame })
    }

    var hasSelection: Bool { !selectedProductNames.isEmpty }
    var selectionCount: Int { selectedProductNames.count }

    // MARK: - Actions
    func isSelected(_ name: String) -> Bool {
        selectedProductNames.contains(name)
    }

    func toggleProduct(_ name: String) {
        if selectedProductNames.contains(name) {
            selectedProductNames.remove(name)
        } else {
            selectedProductNames.insert(name)
        }
    }

    func addCustomProduct() {
        let name = customProductName
        guard !name.isEmpty else { return }
        selectedProductNames.insert(name)
        searchText = ""
    }

    func confirmSelection() {
        guard hasSelection else { return }
        onSelect(Array(selectedProductNames))
        coordinator.dismissTop()
    }

    func dismiss() {
        coordinator.dismissTop()
    }
}
