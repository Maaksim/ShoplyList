//
//  ShoplyListApp.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 27.01.2026.
//

import SwiftUI

@main
struct ShoplyListApp: App {
    @State var appCoordinator = AppCoordinator()

    private var tabBarCoordinator: TabBarCoordinator {
        appCoordinator.tabBarCoordinator
    }

    var body: some Scene {
        WindowGroup {
            tabBarCoordinator.rootView
        }
    }
}
