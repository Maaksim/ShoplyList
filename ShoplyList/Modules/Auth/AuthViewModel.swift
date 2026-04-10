//
//  AuthViewModel.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 10.04.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import AuthenticationServices
import CryptoKit
import Security
import Observation

enum AuthMode {
    case signIn
    case signUp
}

@Observable
@MainActor
final class AuthViewModel {
    var mode: AuthMode = .signIn
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var errorMessage: String?

    private(set) var isLoading: Bool = false

    private var currentNonce: String?
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    var isSignUpMode: Bool { mode == .signUp }

    var isFormValid: Bool {
        guard !email.isEmpty, password.count >= 8 else { return false }
        if mode == .signUp {
            return password == confirmPassword
        }
        return true
    }

    func toggleMode() {
        mode = mode == .signIn ? .signUp : .signIn
        password = ""
        confirmPassword = ""
        errorMessage = nil
    }

    func submitTapped() async {
        guard isFormValid else {
            if mode == .signUp && password != confirmPassword {
                errorMessage = LocalizationConstants.Auth.passwordMismatch
            } else if password.count < 8 {
                errorMessage = LocalizationConstants.Auth.passwordTooShort
            }
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            if mode == .signIn {
                try await authService.signIn(email: email, password: password)
            } else {
                try await authService.signUp(email: email, password: password)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func prepareAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.email, .fullName]
        request.nonce = sha256(nonce)
    }

    func handleAppleCredential(_ authorization: ASAuthorization) async {
        guard
            let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = appleCredential.identityToken,
            let idToken = String(data: tokenData, encoding: .utf8),
            let rawNonce = currentNonce
        else {
            errorMessage = "Apple Sign In failed. Please try again."
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            try await authService.signInWithApple(idToken: idToken, rawNonce: rawNonce)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Nonce helpers

    private func randomNonceString(length: Int = 32) -> String {
        var randomBytes = [UInt8](repeating: 0, count: length)
        _ = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        return String(randomBytes.map { charset[Int($0) % charset.count] })
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
