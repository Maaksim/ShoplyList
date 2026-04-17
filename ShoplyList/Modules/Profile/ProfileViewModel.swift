//
//  ProfileViewModel.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 10.04.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import Observation
import FirebaseAuth

@Observable
@MainActor
final class ProfileViewModel {
    private(set) var isSigningOut = false
    var errorMessage: String?
    var showSignOutConfirmation = false

    var userEmail: String {
        authService.currentUserEmail ?? "—"
    }

    private let authService: any AuthServiceProtocol

    init(authService: any AuthServiceProtocol) {
        self.authService = authService
    }

    func signOutTapped() {
        showSignOutConfirmation = true
    }

    func confirmSignOut() {
        do {
            try authService.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
