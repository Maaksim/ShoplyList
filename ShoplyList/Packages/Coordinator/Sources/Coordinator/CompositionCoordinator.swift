//
//  CompositionCoordinator.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//

import Foundation

public protocol CompositionCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] { get set }
}

public extension CompositionCoordinator {
    func didFinish(childCoordinator: any Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
