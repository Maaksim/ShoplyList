//
//  MockAuthService.swift
//  ShoplyListTests
//
//  Created by Maksym Vitovych on 17.04.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

@testable import ShoplyList

@MainActor
final class MockAuthService: AuthServiceProtocol {
    var isAuthenticated: Bool = false
    var currentUserEmail: String? = nil

    var signInCallCount = 0
    var signUpCallCount = 0
    var signOutCallCount = 0
    var signInWithAppleCallCount = 0

    var capturedSignInEmail: String?
    var capturedSignInPassword: String?
    var capturedSignUpEmail: String?
    var capturedSignUpPassword: String?

    var shouldThrowOnSignIn = false
    var shouldThrowOnSignUp = false
    var shouldThrowOnSignOut = false
    var shouldThrowOnSignInWithApple = false

    enum MockError: LocalizedError {
        case signIn, signUp, signOut, signInWithApple

        var errorDescription: String? {
            switch self {
            case .signIn: "Sign in failed"
            case .signUp: "Sign up failed"
            case .signOut: "Sign out failed"
            case .signInWithApple: "Apple sign in failed"
            }
        }
    }

    func signIn(email: String, password: String) async throws {
        signInCallCount += 1
        capturedSignInEmail = email
        capturedSignInPassword = password
        if shouldThrowOnSignIn { throw MockError.signIn }
    }

    func signUp(email: String, password: String) async throws {
        signUpCallCount += 1
        capturedSignUpEmail = email
        capturedSignUpPassword = password
        if shouldThrowOnSignUp { throw MockError.signUp }
    }

    func signInWithApple(idToken: String, rawNonce: String) async throws {
        signInWithAppleCallCount += 1
        if shouldThrowOnSignInWithApple { throw MockError.signInWithApple }
    }

    func signOut() throws {
        signOutCallCount += 1
        if shouldThrowOnSignOut { throw MockError.signOut }
    }
}
