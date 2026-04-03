//
//  NavigationType.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//

import SwiftUI

public enum NavigationType {
    /// A push transition style, commonly used in navigation controllers.
    case push
    /// A presentation style, often used for modal or overlay views.
    case present(PresentationType)
}

public enum PresentationType {
    /// A sheet presentation style
    case sheet(Set<PresentationDetent>? = nil)
    /// A full-screen cover presentation style.
    case fullScreenCover
}

public extension NavigationType {
    var presentationType: PresentationType? {
        guard case .present(let presentationType) = self else {
            return nil
        }

        return presentationType
    }
}

public extension PresentationType {
    // ignores detents for sheets
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case (.sheet, .sheet): return true
            case (.fullScreenCover, .fullScreenCover): return true
            default: return false
        }
    }
    
    var detents: Set<PresentationDetent>? {
        guard case .sheet(let detents) = self else {
            return nil
        }
        return detents
    }
}
