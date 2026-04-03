//
//  ProductPickerView.swift
//  ShoplyList
//
//  Created on 03.04.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import SwiftUI

struct ProductPickerView: View {
    @State private var viewModel: ProductPickerViewModel
    @FocusState private var isSearchFocused: Bool

    init(viewModel: ProductPickerViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            backgroundView
            VStack(spacing: 0) {
                navigationBar
                tabPicker
                productList
                confirmButton
            }
        }
    }
}

// MARK: - Background
extension ProductPickerView {
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
}

// MARK: - Navigation Bar
extension ProductPickerView {
    private var navigationBar: some View {
        HStack(spacing: 12) {
            dismissButton
            searchField
            cameraButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private var dismissButton: some View {
        Button(action: viewModel.dismiss) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(.primaryPurple))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(Color(.cardBackground))
                )
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(Color(.textSecondary))

            TextField("", text: $viewModel.searchText,
                      prompt: Text(LocalizationConstants.ProductPicker.searchPlaceholder)
                          .foregroundColor(Color(.textSecondary)))
                .font(.system(size: 16))
                .foregroundStyle(Color(.textPrimary))
                .focused($isSearchFocused)
                .submitLabel(.done)
                .onSubmit {
                    if viewModel.showCustomAddRow {
                        viewModel.addCustomProduct()
                    }
                }

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(.textSecondary))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.cardBackground))
        )
    }

    private var cameraButton: some View {
        Button {} label: {
            Image(systemName: "camera")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color(.textSecondary))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(Color(.cardBackground))
                )
        }
    }
}

// MARK: - Tab Picker
extension ProductPickerView {
    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(ProductPickerViewModel.Tab.allCases, id: \.self) { tab in
                tabButton(tab)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.primaryPurple).opacity(0.08))
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }

    private func tabButton(_ tab: ProductPickerViewModel.Tab) -> some View {
        Button {
            viewModel.selectedTab = tab
        } label: {
            Text(tab.title)
                .font(.system(
                    size: 15,
                    weight: viewModel.selectedTab == tab ? .semibold : .regular
                ))
                .foregroundStyle(
                    viewModel.selectedTab == tab
                        ? Color(.textPrimary)
                        : Color(.textSecondary)
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.selectedTab == tab
                              ? Color(.cardBackground)
                              : Color.clear)
                        .shadow(
                            color: viewModel.selectedTab == tab
                                ? Color(.cardShadow).opacity(0.15)
                                : Color.clear,
                            radius: 4
                        )
                )
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedTab)
    }
}

// MARK: - Products List
extension ProductPickerView {
    private var productList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if viewModel.showCustomAddRow {
                    customProductRow
                    listDivider
                }

                if viewModel.filteredProducts.isEmpty && !viewModel.showCustomAddRow {
                    emptyResultsView
                } else {
                    ForEach(viewModel.filteredProducts, id: \.self) { product in
                        productRow(product)
                        if product != viewModel.filteredProducts.last {
                            listDivider
                        }
                    }
                }
            }
            .padding(.top, 4)
            .padding(.bottom, 16)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var customProductRow: some View {
        HStack(spacing: 12) {
            addCircleButton {
                viewModel.addCustomProduct()
            }

            Text(LocalizationConstants.ProductPicker.addCustomFormat(viewModel.customProductName))
                .font(.system(size: 17))
                .foregroundStyle(Color(.primaryPurple))

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.addCustomProduct()
        }
    }

    private func productRow(_ name: String) -> some View {
        HStack(spacing: 12) {
            if viewModel.isSelected(name) {
                selectedCircleButton {
                    viewModel.toggleProduct(name)
                }
            } else {
                addCircleButton {
                    viewModel.toggleProduct(name)
                }
            }

            Text(name)
                .font(.system(size: 17))
                .foregroundStyle(Color(.textPrimary))

            Spacer()

            if viewModel.isSelected(name) {
                removeButton(for: name)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }

    private func addCircleButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color(.cardBackground))
                    .frame(width: 34, height: 34)
                    .shadow(color: Color(.cardShadow).opacity(0.1), radius: 3)

                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(.primaryPurple))
            }
        }
    }

    private func selectedCircleButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(.primaryPurple), Color(.secondaryPurple)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 34, height: 34)

                Image(systemName: "checkmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }

    private func removeButton(for name: String) -> some View {
        Button {
            viewModel.toggleProduct(name)
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.red)
                .frame(width: 26, height: 26)
                .background(
                    Circle()
                        .fill(Color.red.opacity(0.12))
                )
        }
    }

    private var listDivider: some View {
        Divider()
            .padding(.horizontal, 20)
    }

    private var emptyResultsView: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(Color(.primaryPurple).opacity(0.4))
            Text(LocalizationConstants.ProductPicker.noResults)
                .font(.system(size: 16))
                .foregroundStyle(Color(.textSecondary))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - Confirm Button
extension ProductPickerView {
    @ViewBuilder
    private var confirmButton: some View {
        if viewModel.hasSelection {
            Button(action: viewModel.confirmSelection) {
                confirmButtonLabel
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.spring(duration: 0.3), value: viewModel.hasSelection)
        }
    }

    private var confirmButtonLabel: some View {
        Text(LocalizationConstants.ProductPicker.addItemsButton(viewModel.selectionCount))
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color(.primaryPurple), Color(.secondaryPurple)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: Color(.primaryPurple).opacity(0.4), radius: 6, y: 3)
            )
    }
}

#Preview {
    ProductPickerView(
        viewModel: ProductPickerViewModel(
            coordinator: ListsCoordinator(),
            onSelect: { _ in }
        )
    )
}
