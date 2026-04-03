//
//  TabBarCoordinator.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//

import SwiftUI
import Coordinator

@Observable
final class TabBarCoordinator: CompositionCoordinator {
    var childCoordinators = [any Coordinator]()
    var finishDelegate: (any CoordinatorFinishDelegate)?
    
    let listTabCoordinator = ListsCoordinator()
    let profileTabCoordinator = ListsCoordinator()

    var activeTab = TabItem.listsTab

    var rootView: some View {
        TabBarView(coordinator: self)
    }

    @MainActor
    func tabView(for tab: TabItem) -> some View {
        switch tab {
        case .listsTab:
            listTabCoordinator.rootView
        case .profileTab:
            profileTabCoordinator.rootView
        }
    }
    
    func setCurrentTab(_ tab: TabItem) {
        activeTab = tab
    }

    deinit {
        print("Deinit TabBarCoordinator")
    }
}
