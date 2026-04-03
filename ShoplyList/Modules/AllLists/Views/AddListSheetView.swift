//
//  AddListSheetView.swift
//  ShoplyList
//
//  Created on 12.02.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import SwiftUI

struct AddListSheetView: View {
    @State private var listName: String = ""
    @FocusState private var isTextFieldFocused: Bool

    let onCreate: @MainActor (String) -> Void
    let onDismiss: () -> Void

    private var isCreateButtonDisabled: Bool {
        listName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            backgroundColor
            contentView
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

// MARK: - UI Components
extension AddListSheetView {
    private var backgroundColor: some View {
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

    private var contentView: some View {
        VStack(spacing: 12) {
            iconView
            titleView
            textFieldView
            createButton
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
    }

    private var iconView: some View {
        ZStack {
            Circle()
                .fill(iconGradient)
                .frame(width: 42, height: 42)

            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color(.primaryPurple))
        }
    }

    private var iconGradient: some ShapeStyle {
        LinearGradient(
            colors: [
                Color(.primaryPurple).opacity(0.15),
                Color(.secondaryPurple).opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var titleView: some View {
        Text(LocalizationConstants.AddListPopup.title)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color(.textPrimary))
    }

    private var textFieldView: some View {
        TextField("", text: $listName,
                  prompt: placeholderLabel)
        .font(.system(size: 15))
        .padding(14)
        .background(textFieldBackground)
        .focused($isTextFieldFocused)
        .submitLabel(.done)
        .foregroundStyle(.textPrimary)
        .onSubmit {
            if !isCreateButtonDisabled {
                createList()
            }
        }
    }

    private var placeholderLabel: Text {
        Text(LocalizationConstants.AddListPopup.namePlaceholder)
            .foregroundColor(.textSecondary)
    }

    private var textFieldBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color(.primaryPurple).opacity(0.3), lineWidth: 1.5)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.cardBackground))
            )
    }

    private var createButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.primaryPurple)
                .opacity(isCreateButtonDisabled ? 0.3 : 1)
            Text(LocalizationConstants.AddListPopup.createButton)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 58)
        .disabled(isCreateButtonDisabled)
        .padding(.vertical, 16)
        .onTapGesture {
            createList()
        }
    }
}

// MARK: - Actions
extension AddListSheetView {
    private func createList() {
        let trimmedName = listName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        onCreate(trimmedName)
        onDismiss()
    }
}

#Preview {
    AddListSheetView(
        onCreate: { name in
            print("Created list: \(name)")
        },
        onDismiss: {}
    )
}
