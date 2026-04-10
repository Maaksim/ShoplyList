//
//  ShoplyListApp.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 27.01.2026.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ShoplyListApp: App {
    @State var appCoordinator = AppCoordinator()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            appCoordinator.rootView
        }
    }
}
