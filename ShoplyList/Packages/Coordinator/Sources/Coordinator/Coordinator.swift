//
//  Coordinator.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//

import SwiftUI

public protocol CoordinatorFinishDelegate: AnyObject {
    func didFinish(childCoordinator: any Coordinator)
}

public protocol Coordinator: CoordinatorFinishDelegate {
    associatedtype Content: View
    @MainActor @ViewBuilder var rootView: Content { get }
    
    var finishDelegate: CoordinatorFinishDelegate? { get set }

    func finish()
}

public extension Coordinator {
    func finish() {
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
