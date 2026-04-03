//
//  Routable.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//

import Foundation

public protocol Routable: Hashable {
    var navigationType: NavigationType { get }
}
