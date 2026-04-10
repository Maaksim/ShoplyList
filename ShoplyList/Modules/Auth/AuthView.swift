//
//  AuthView.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 10.04.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @State private var viewModel: AuthViewModel

    init(viewModel: AuthViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            backgroundView
            ScrollView {
                VStack(spacing: 32) {
                    logoView
                    formView
                    if let error = viewModel.errorMessage {
                        errorView(error)
                    }
                    primaryButton
                    orDivider
                    appleSignInButton
                    toggleModeButton
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 40)
            }
            .scrollBounceBehavior(.basedOnSize)
            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.mode)
        .animation(.easeInOut(duration: 0.25), value: viewModel.errorMessage)
    }
}

// MARK: - UI Components
extension AuthView {

    // MARK: - Background
    private var backgroundView: some View {
        LinearGradient(
            colors: [
                Color(.backgroundGradientTop),
                Color(.backgroundGradientBottom)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    // MARK: - Logo
    private var logoView: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(.primaryPurple), Color(.secondaryPurple)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 72, height: 72)
                    .shadow(color: Color(.primaryPurple).opacity(0.4), radius: 12, y: 6)

                Image(systemName: "cart.fill")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 6) {
                Text(viewModel.isSignUpMode
                     ? LocalizationConstants.Auth.signUpTitle
                     : LocalizationConstants.Auth.signInTitle)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(.textPrimary))

                Text(viewModel.isSignUpMode
                     ? LocalizationConstants.Auth.signUpSubtitle
                     : LocalizationConstants.Auth.signInSubtitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color(.textSecondary))
            }
        }
    }

    // MARK: - Form
    private var formView: some View {
        VStack(spacing: 12) {
            emailField
            passwordField
            if viewModel.isSignUpMode {
                confirmPasswordField
            }
        }
    }

    private var emailField: some View {
        TextField(LocalizationConstants.Auth.emailPlaceholder, text: $viewModel.email)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.cardBackground))
                    .shadow(color: Color(.cardShadow), radius: 6, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.primaryPurple).opacity(0.3), lineWidth: 1.5)
            )
            .disabled(viewModel.isLoading)
    }

    private var passwordField: some View {
        SecureField(LocalizationConstants.Auth.passwordPlaceholder, text: $viewModel.password)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.cardBackground))
                    .shadow(color: Color(.cardShadow), radius: 6, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.primaryPurple).opacity(0.3), lineWidth: 1.5)
            )
            .disabled(viewModel.isLoading)
    }

    private var confirmPasswordField: some View {
        SecureField(LocalizationConstants.Auth.confirmPasswordPlaceholder, text: $viewModel.confirmPassword)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.cardBackground))
                    .shadow(color: Color(.cardShadow), radius: 6, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.primaryPurple).opacity(0.3), lineWidth: 1.5)
            )
            .disabled(viewModel.isLoading)
    }

    // MARK: - Error
    private func errorView(_ message: String) -> some View {
        Text(message)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.red)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 4)
    }

    // MARK: - Primary Button
    private var primaryButton: some View {
        Button {
            Task { await viewModel.submitTapped() }
        } label: {
            Text(viewModel.isSignUpMode
                 ? LocalizationConstants.Auth.signUpButton
                 : LocalizationConstants.Auth.signInButton)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(
                    LinearGradient(
                        colors: [Color(.primaryPurple), Color(.secondaryPurple)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                )
                .shadow(color: Color(.primaryPurple).opacity(0.35), radius: 8, y: 4)
        }
        .opacity(viewModel.isFormValid ? 1.0 : 0.3)
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
    }

    // MARK: - Or Divider
    private var orDivider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color(.textSecondary).opacity(0.3))
                .frame(height: 1)
            Text(LocalizationConstants.Auth.orDivider)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color(.textSecondary))
            Rectangle()
                .fill(Color(.textSecondary).opacity(0.3))
                .frame(height: 1)
        }
    }

    // MARK: - Apple Sign In
    private var appleSignInButton: some View {
        SignInWithAppleButton(
            onRequest: { request in
                viewModel.prepareAppleRequest(request)
            },
            onCompletion: { result in
                if case .success(let authorization) = result {
                    Task { await viewModel.handleAppleCredential(authorization) }
                } else if case .failure(let error) = result {
                    viewModel.errorMessage = error.localizedDescription
                }
            }
        )
        .signInWithAppleButtonStyle(.black)
        .frame(height: 58)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .disabled(viewModel.isLoading)
    }

    // MARK: - Toggle Mode
    private var toggleModeButton: some View {
        Button {
            viewModel.toggleMode()
        } label: {
            Text(viewModel.isSignUpMode
                 ? LocalizationConstants.Auth.toggleToSignIn
                 : LocalizationConstants.Auth.toggleToSignUp)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(.primaryPurple))
        }
        .disabled(viewModel.isLoading)
    }

    // MARK: - Loading Overlay
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.15)
                .ignoresSafeArea()
            ProgressView()
                .scaleEffect(1.3)
                .tint(Color(.primaryPurple))
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel(authService: AuthService()))
}
