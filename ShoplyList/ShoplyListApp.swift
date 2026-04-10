//
//  ShoplyListApp.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 27.01.2026.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {}

@main
struct ShoplyListApp: App {
    @State var appCoordinator: AppCoordinator
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        FirebaseApp.configure()
        _appCoordinator = State(wrappedValue: AppCoordinator())
    }

    var body: some Scene {
        WindowGroup {
            appCoordinator.rootView
        }
    }
}
