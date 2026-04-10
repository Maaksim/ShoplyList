//
//  ProfileView.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 10.04.2026.
//  Copyright © 2026 Shoply. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            backgroundView
            VStack(spacing: 0) {
                headerView
                contentView
            }
        }
        .confirmationDialog(
            "Sign out of your account?",
            isPresented: $viewModel.showSignOutConfirmation,
            titleVisibility: .visible
        ) {
            Button("Sign Out", role: .destructive) {
                viewModel.confirmSignOut()
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// MARK: - UI Components
extension ProfileView {

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

    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Profile")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(.textPrimary))
                Text("Account settings")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(.textSecondary))
            }
            Spacer(minLength: 0)
        }
        .padding([.horizontal, .bottom], 20)
        .padding(.top, 16)
    }

    // MARK: - Content
    private var contentView: some View {
        VStack(spacing: 16) {
            avatarCard
            accountSection
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // MARK: - Avatar Card
    private var avatarCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(.primaryPurple), Color(.secondaryPurple)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                Text(avatarInitial)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.userEmail)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color(.textPrimary))
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text("Signed in")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(.primaryPurple))
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.cardBackground))
                .shadow(color: Color(.cardShadow), radius: 12, y: 4)
        )
    }

    // MARK: - Account Section
    private var accountSection: some View {
        VStack(spacing: 0) {
            signOutRow
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.cardBackground))
                .shadow(color: Color(.cardShadow), radius: 12, y: 4)
        )
    }

    private var signOutRow: some View {
        Button {
            viewModel.signOutTapped()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.red.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.red)
                }
                Text("Sign Out")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.red)
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(.textSecondary).opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }

    // MARK: - Helpers
    private var avatarInitial: String {
        viewModel.userEmail.first.map(String.init)?.uppercased() ?? "?"
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(authService: AuthService()))
}
