//
//  TabBarView.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @Bindable var coordinator: TabBarCoordinator

    var body: some View {
//        let _ = print("Update TabBarView body for TabBarCoordinator \n")

        TabView(selection: $coordinator.activeTab) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Tab(tab.title, systemImage: tab.iconName, value: tab) {
                    coordinator.tabView(for: tab)
                }
            }
        }
    }
}
