//
//  TabItems.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

enum TabItem: Int, CaseIterable {
    case listsTab
    case profileTab

    var title: String {
        switch self {
        case .listsTab:
            return "Lists"
        case .profileTab:
            return "Profile"
        }
    }

    var iconName: String {
        switch self {
        case .listsTab:
            return "list.bullet"
        case .profileTab:
            return "person.crop.circle"
        }
    }
}
