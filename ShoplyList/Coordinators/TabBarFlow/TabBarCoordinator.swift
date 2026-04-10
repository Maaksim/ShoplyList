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
    let authService: AuthService

    var activeTab = TabItem.listsTab

    init(authService: AuthService) {
        self.authService = authService
    }

    var rootView: some View {
        TabBarView(coordinator: self)
    }

    @MainActor
    func tabView(for tab: TabItem) -> some View {
        switch tab {
        case .listsTab:
            listTabCoordinator.rootView
        case .profileTab:
            ProfileAssembly().make(authService: authService)
        }
    }
    
    func setCurrentTab(_ tab: TabItem) {
        activeTab = tab
    }

    deinit {
        print("Deinit TabBarCoordinator")
    }
}
