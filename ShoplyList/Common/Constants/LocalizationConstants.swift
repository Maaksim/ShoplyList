//
//  LocalizationConstants.swift
//  ShoplyList
//
//  Created on 11.02.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import Foundation

enum LocalizationConstants {
    // MARK: - All Lists Screen
    enum AllLists {
        static let title = "Shopping Lists"
        static let noLists = "No Shopping Lists"
        static let emptyStateMessage = "Tap the + button to create\nyour first shopping list"
        static let retry = "Retry"
        static let delete = "Delete"
        static let oneItem = "1 item"

        static func listsCount(_ count: Int) -> String {
            "\(count) lists"
        }

        static func itemsCount(_ count: Int) -> String {
            "\(count) items"
        }

        static func listTitle(_ id: Int) -> String {
            "List #\(id)"
        }
    }

    // MARK: - List Details Screen
    enum ListDetails {
        static let noItems = "No Items Yet"
        static let emptyStateMessage = "Tap the + button to add\nyour first item"
        static let completedSection = "Completed"
        static let activeSection = "Active"
        static let delete = "Delete"
        static let edit = "Edit"

        static func itemsCount(_ count: Int) -> String {
            count == 1 ? "1 item" : "\(count) items"
        }

        static func completedCount(_ completed: Int, total: Int) -> String {
            "\(completed) of \(total) completed"
        }
    }

    // MARK: - Add/Edit Item
    enum AddEditItem {
        static let addTitle = "Add Item"
        static let editTitle = "Edit Item"
        static let nameLabel = "Item Name"
        static let namePlaceholder = "Enter item name..."
        static let countLabel = "Quantity"
        static let priceLabel = "Price"
        static let pricePlaceholder = "0.00"
        static let addButton = "Add Item"
        static let saveButton = "Save Changes"
    }

    // MARK: - Add List Popup
    enum AddListPopup {
        static let title = "New Shopping List"
        static let nameLabel = "List Name"
        static let namePlaceholder = "Enter list name..."
        static let createButton = "Create"
    }

    // MARK: - Common
    enum Common {
        static let error = "Error"
        static let ok = "OK"
        static let cancel = "Cancel"
        static let save = "Save"
        static let done = "Done"
        static let edit = "Edit"
        static let add = "Add"
    }

    // MARK: - Product Picker
    enum ProductPicker {
        static let title = "Add Product"
        static let searchPlaceholder = "Search products..."
        static let popular = "Popular"
        static let recent = "Recent"
        static let noResults = "No products found"

        static func addItemsButton(_ count: Int) -> String {
            count == 1 ? "Add 1 item" : "Add \(count) items"
        }

        static func addCustomFormat(_ name: String) -> String {
            "Add \"\(name)\""
        }
    }

    // MARK: - Tab Bar
    enum TabBar {
        static let lists = "Lists"
        static let profile = "Profile"
    }
}
