//
//  AddEditItemSheetView.swift
//  ShoplyList
//
//  Created on 12.02.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import SwiftUI

struct AddEditItemSheetView: View {
    @State private var itemName: String
    @State private var itemCount: Int
    @State private var itemPrice: String
    @FocusState private var focusedField: Field?

    let editingItem: ProductItemDTO?
    let onSave: @MainActor (ProductItemDTO) -> Void
    let onDismiss: () -> Void

    private var isEditing: Bool {
        editingItem != nil
    }

    private var title: String {
        isEditing
            ? LocalizationConstants.AddEditItem.editTitle
            : LocalizationConstants.AddEditItem.addTitle
    }

    private var buttonTitle: String {
        isEditing
            ? LocalizationConstants.AddEditItem.saveButton
            : LocalizationConstants.AddEditItem.addButton
    }

    private var isSaveButtonDisabled: Bool {
        itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var priceValue: Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current

        // Try current locale first (handles comma decimal separator)
        if let number = formatter.number(from: itemPrice) {
            return number.doubleValue
        }

        // Fallback: try replacing comma with period
        let normalizedPrice = itemPrice.replacingOccurrences(of: ",", with: ".")
        return Double(normalizedPrice) ?? 0.0
    }

    init(editingItem: ProductItemDTO? = nil,
         onSave: @escaping @MainActor (ProductItemDTO) -> Void,
         onDismiss: @escaping () -> Void) {
        self.editingItem = editingItem
        self.onSave = onSave
        self.onDismiss = onDismiss

        _itemName = State(initialValue: editingItem?.title ?? "")
        _itemCount = State(initialValue: editingItem?.count ?? 1)
        _itemPrice = State(initialValue: editingItem.map { String(format: "%.2f", $0.price) } ?? "")
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            contentView
        }
        .onAppear {
            focusedField = .name
        }
    }

    private func saveItem() {
        let trimmedName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let item = ProductItemDTO(
            id: editingItem?.id ?? UUID(),
            title: trimmedName,
            count: itemCount,
            price: priceValue,
            isCompleted: editingItem?.isCompleted ?? false
        )

        onSave(item)
        onDismiss()
    }
}

// MARK: - UI Components
extension AddEditItemSheetView {
    private var backgroundColor: some View {
        LinearGradient(
            colors: [
                Color(.backgroundGradientTop),
                Color(.backgroundGradientBottom)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var contentView: some View {
        VStack(spacing: 12) {
            iconView
            titleView
            textFieldsView
            buttonsView
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
    }

    private var iconView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.primaryPurple).opacity(0.15),
                            Color(.secondaryPurple).opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 42, height: 42)

            Image(systemName: isEditing ? "pencil" : "cart.badge.plus")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color(.primaryPurple))
        }
    }

    private var titleView: some View {
        Text(title)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color(.textPrimary))
    }

    private var buttonsView: some View {
        HStack(spacing: 12) {
            cancelButton
            saveButton
        }
        .padding(.top, 8)
    }

    private var cancelButton: some View {
        Button(LocalizationConstants.Common.cancel) {
            onDismiss()
        }
        .font(.system(size: 15, weight: .medium))
        .foregroundStyle(Color(.primaryPurple))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.primaryPurple), lineWidth: 1.5)
        )
    }

    private var saveButton: some View {
        Button(buttonTitle) {
            saveItem()
        }
        .font(.system(size: 15, weight: .semibold))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.primaryPurple)
                .opacity(isSaveButtonDisabled ? 0.3 : 1)
        )
        .disabled(isSaveButtonDisabled)
    }
}

// MARK: - Text fields UI
extension AddEditItemSheetView {
    private var textFieldsView: some View {
        VStack(spacing: 14) {
            nameFieldView

            HStack(spacing: 12) {
                countFieldView
                priceFieldView
            }
        }
    }

    private func textFieldHeader(with text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(.textSecondary)
    }

    private var nameFieldView: some View {
        VStack(alignment: .leading, spacing: 5) {
            textFieldHeader(with: LocalizationConstants.AddEditItem.nameLabel)

            TextField("", text: $itemName,
                      prompt: namePlaceholderLabel)
            .font(.system(size: 15))
            .foregroundStyle(.textPrimary)
            .padding(14)
            .background(textFieldBackground)
            .focused($focusedField, equals: .name)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .price
            }
        }
    }

    private var namePlaceholderLabel: Text {
        Text(LocalizationConstants.AddEditItem.namePlaceholder)
            .foregroundColor(.textSecondary)
    }

    private var countFieldView: some View {
        VStack(alignment: .leading, spacing: 5) {
            textFieldHeader(with: LocalizationConstants.AddEditItem.countLabel)

            HStack(spacing: 0) {
                countButton(systemName: "minus", action: decrementCount)

                Text("\(itemCount)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.textPrimary)
                    .frame(minWidth: 50)

                countButton(systemName: "plus", action: incrementCount)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .background(textFieldBackground)
        }
    }

    private func countButton(systemName: String,
                             action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color(.primaryPurple))
                .frame(width: 48, height: 40)
        }
    }

    private func incrementCount() {
        itemCount += 1
    }

    private func decrementCount() {
        if itemCount > 1 {
            itemCount -= 1
        }
    }

    private var priceFieldView: some View {
        VStack(alignment: .leading, spacing: 5) {
            textFieldHeader(with: LocalizationConstants.AddEditItem.priceLabel)

            HStack {
                Text("$")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color(.primaryPurple))

                TextField("", text: $itemPrice,
                          prompt: pricePlaceholderLabel)
                .font(.system(size: 15))
                .foregroundStyle(.textPrimary)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: .price)
            }
            .padding(14)
            .background(textFieldBackground)
        }
    }

    private var pricePlaceholderLabel: Text {
        Text(LocalizationConstants.AddEditItem.pricePlaceholder)
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
}

// MARK: - Field types
extension AddEditItemSheetView {
    private enum Field {
        case name, price
    }
}

#Preview("Add Item") {
    AddEditItemSheetView(
        onSave: { _ in },
        onDismiss: {}
    )
}

#Preview("Edit Item") {
    AddEditItemSheetView(
        editingItem: ProductItemDTO(
            title: "Organic Milk",
            count: 2,
            price: 4.99,
            isCompleted: false
        ),
        onSave: { _ in },
        onDismiss: {}
    )
}
