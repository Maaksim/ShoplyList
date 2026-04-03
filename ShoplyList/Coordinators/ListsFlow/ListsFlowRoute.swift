//
//  ListsFlowRoute.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//

import SwiftUI
import Coordinator

enum ListsFlowRoute: @MainActor Routable {
    case addList(onCreate: @MainActor (String) -> Void)
    case listDetails(list: ProductsListDTO)
    case addEditItem(editingItem: ProductItemDTO?, onSave: @MainActor (ProductItemDTO) -> Void)
    case productPicker(onSelect: @MainActor ([String]) -> Void)

    var navigationType: NavigationType {
        switch self {
        case .addList:
            return .present(.sheet([.height(360)]))
        case .listDetails:
            return .push
        case .addEditItem:
            return .present(.sheet([.height(360)]))
        case .productPicker:
            return .present(.fullScreenCover)
        }
    }

    // MARK: - Equatable
    static func == (lhs: ListsFlowRoute, rhs: ListsFlowRoute) -> Bool {
        switch (lhs, rhs) {
        case (.addList, .addList):
            return true
        case (.listDetails(let lhsList), .listDetails(let rhsList)):
            return lhsList.id == rhsList.id
        case (.addEditItem, .addEditItem):
            return true
        case (.productPicker, .productPicker):
            return true
        default:
            return false
        }
    }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .addList:
            hasher.combine("addList")
        case .listDetails(let list):
            hasher.combine("listDetails")
            hasher.combine(list.id)
        case .addEditItem:
            hasher.combine("addEditItem")
        case .productPicker:
            hasher.combine("productPicker")
        }
    }
}
