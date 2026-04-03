//
//  FlowCoordinator.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//

import SwiftUI

public protocol FlowCoordinator: Coordinator {
    associatedtype Route: Routable
    associatedtype Destination: View
    
    var childCoordinator: (any Coordinator)? { get set }
    var navigationControllers: [NavigationController<Route>] { get set }
    
    @MainActor @ViewBuilder func destination(for route: Route) -> Destination
}

public extension FlowCoordinator {
    func present(child: any Coordinator) {
        childCoordinator = child
        child.finishDelegate = self
    }
    
    func dismissChild() {
        childCoordinator = nil
    }
    
    func didFinish(childCoordinator: any Coordinator) {
        dismissChild()
    }
}

public extension FlowCoordinator {
    func setupInitialNavigationController() {
        navigationControllers.append(
            NavigationController { [weak self] nc in
                self?.dismissNavigationController(nc)
            }
        )
    }
    
    func push(route: Route) {
        topNavigationController.navigationPath.append(route)
    }
    
    func popLast() {
        guard topNavigationController.navigationPath.count > 0 else {
            return
        }

        navigationControllers.last?.navigationPath.removeLast()
    }
    
    func popToRoot() {
        let routesCount = topNavigationController.navigationPath.count
        guard routesCount > 0 else { return }
        navigationControllers.last?.navigationPath.removeLast(routesCount)
    }
    
    func present(route: Route) {
        topNavigationController.presentedRoute = route
        let nc = NavigationController<Route> { [weak self] nc in
            self?.dismissNavigationController(nc)
        }
        navigationControllers.append(nc)
    }
    
    func dismissTop() {
        guard navigationControllers.count > 1 else { return }
        navigationControllers.removeLast()
        topNavigationController.presentedRoute = nil
    }
    
    func dismissToRoot() {
        childCoordinator?.finish()
        
        guard navigationControllers.count > 1 else { return }
        navigationControllers.removeLast(navigationControllers.count - 1)
        rootNavigationController.presentedRoute = nil
    }
    
    func dismissNavigationController(_ nc: NavigationController<Route>) {
        guard let index = navigationControllers.firstIndex(where: { $0 === nc }) else {
            return
        }
        navigationControllers.removeLast(navigationControllers.count - 1 - index)
    }
    
    func isTopNavigationController(_ nc: NavigationController<Route>) -> Bool {
        navigationControllers.last === nc
    }
    
    func shouldPresentChild(from nc: NavigationController<Route>) -> Binding<Bool> {
        Binding<Bool> { [weak self] in
            guard let self else { return false }
            return self.childCoordinator != nil && self.isTopNavigationController(nc)
        } set: { [weak self] newValue in
            guard !newValue else { return }
            self?.dismissChild()
        }
    }
    
    var rootNavigationController: NavigationController<Route> {
        guard let nc = navigationControllers.first else {
            fatalError("Root navigation controller not found")
        }
        return nc
    }
    
    var topNavigationController: NavigationController<Route> {
        guard let nc = navigationControllers.last else {
            fatalError("Top navigation controller not found")
        }

        return nc
    }
}
