//
//  AuthService.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 10.04.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import FirebaseAuth
import AuthenticationServices
import Observation

@MainActor
protocol AuthServiceProtocol: AnyObject {
    var isAuthenticated: Bool { get }
    var currentUserEmail: String? { get }
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func signInWithApple(idToken: String, rawNonce: String) async throws
    func signOut() throws
}

@Observable
@MainActor
final class AuthService: AuthServiceProtocol {
    private(set) var currentUser: FirebaseAuth.User?

    var isAuthenticated: Bool { currentUser != nil }
    var currentUserEmail: String? { currentUser?.email }

    private var listenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        currentUser = Auth.auth().currentUser
        listenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUser = user
            }
        }
    }

    isolated deinit {
        if let handle = listenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func signInWithApple(idToken: String, rawNonce: String) async throws {
        let credential = OAuthProvider.credential(
            providerID: AuthProviderID.apple,
            idToken: idToken,
            rawNonce: rawNonce
        )
        try await Auth.auth().signIn(with: credential)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
