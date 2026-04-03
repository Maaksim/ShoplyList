//
//  NavigatingView.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//

import SwiftUI

public struct NavigatingView<SomeCoordinator: FlowCoordinator>: View {
    @State var nc: NavigationController<SomeCoordinator.Route>
    @State var coordinator: SomeCoordinator

    public init(nc: NavigationController<SomeCoordinator.Route>,
                coordinator: SomeCoordinator,
                content: @escaping () -> any View) {
        self.nc = nc
        self.coordinator = coordinator
        self.content = content
    }

    public var content: () -> any View
    
    public var body: some View {
//        let _ = print(
//            """
//            Update NavigatingView body for \(SomeCoordinator.self)
//            nc: \(Unmanaged.passUnretained(nc).toOpaque())\n
//            """
//        )
        NavigationStack(path: $nc.navigationPath) {
            AnyView(content())
                .navigationDestination(for: SomeCoordinator.Route.self) {
                    coordinator.destination(for: $0)
                }
        }
        .sheet(isPresented: nc.isPresenting(with: .sheet())) {
            let detents = nc.presentedRoute?.navigationType.presentationType?.detents
            viewToPresent
                .presentationDetents(detents ?? .init())
        }
        .fullScreenCover(isPresented: nc.isPresenting(with: .fullScreenCover)) {
            viewToPresent
        }
        .sheet(isPresented: coordinator.shouldPresentChild(from: nc)) {
            if let childCoordinator = coordinator.childCoordinator {
                AnyView(childCoordinator.rootView)
            }
        }
    }
    
    @ViewBuilder
    private var viewToPresent: some View {
        if let route = nc.presentedRoute {
            NavigatingView(
                nc: coordinator.topNavigationController,
                coordinator: coordinator
            ) {
                coordinator.destination(for: route)
            }
        }
    }
}
