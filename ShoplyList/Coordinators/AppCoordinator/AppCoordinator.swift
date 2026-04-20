//
//  AppCoordinator.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import SwiftUI

@Observable
final class AppCoordinator {
    let authService: AuthService
    let tabBarCoordinator: TabBarCoordinator

    init() {
        let authService = AuthService()
        self.authService = authService
        self.tabBarCoordinator = TabBarCoordinator(authService: authService)
    }

    @MainActor
    var rootView: some View {
        Group {
            if authService.isAuthenticated {
                tabBarCoordinator.rootView
            } else {
                AuthAssembly().make(authService: authService)
            }
        }
    }
}
