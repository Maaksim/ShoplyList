//
//  ListDetailsView.swift
//  ShoplyList
//
//  Created on 12.02.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import SwiftUI

struct ListDetailsView: View {
    @State private var viewModel: ListDetailsViewModel

    init(viewModel: ListDetailsViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            backgroundColor

            VStack(spacing: 0) {
                headerView
                contentView
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

// MARK: - UI Components
extension ListDetailsView {
    // MARK: - Background
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

    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 0) {
            navigationBar
            titleSection
        }
    }

    private var navigationBar: some View {
        HStack {
            backButton
            Spacer()
            addButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var backButton: some View {
        Button(action: viewModel.goBack) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text(LocalizationConstants.TabBar.lists)
                    .font(.system(size: 17))
            }
            .foregroundStyle(Color(.primaryPurple))
        }
    }

    private var addButton: some View {
        Button(action: viewModel.showProductPicker) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(
                    LinearGradient(
                        colors: [
                            Color(.primaryPurple),
                            Color(.secondaryPurple)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: Color(.primaryPurple).opacity(0.4), radius: 6, y: 3)
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.list.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color(.textPrimary))
                .lineLimit(2)

            HStack(spacing: 16) {
                subtitleInfo(
                    icon: "cart",
                    text: LocalizationConstants.ListDetails.itemsCount(viewModel.list.items.count)
                )

                if !viewModel.list.items.isEmpty {
                    subtitleInfo(
                        icon: "checkmark.circle",
                        text: viewModel.completedCountText
                    )
                }

                if viewModel.totalPrice > 0 {
                    subtitleInfo(
                        icon: "dollarsign.circle",
                        text: viewModel.formattedTotalPrice
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private func subtitleInfo(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(text)
                .font(.system(size: 14, weight: .medium))
        }
        .foregroundStyle(.textSecondary)
    }

    // MARK: - Content
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if let error = viewModel.errorMessage {
            errorView(error)
        } else if viewModel.list.items.isEmpty {
            emptyStateView
        } else {
            itemsListView
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Spacer()
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color(.primaryPurple).opacity(0.1))
                    .frame(width: 100, height: 100)

                Image(systemName: "cart")
                    .font(.system(size: 44))
                    .foregroundStyle(Color(.primaryPurple).opacity(0.6))
            }

            Text(LocalizationConstants.ListDetails.noItems)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(.textPrimary))

            Text(LocalizationConstants.ListDetails.emptyStateMessage)
                .font(.system(size: 15))
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
    }

    private var itemsListView: some View {
        List {
            // Active Items Section
            if !viewModel.activeItems.isEmpty {
                Section {
                    ForEach(viewModel.activeItems) { item in
                        itemRow(item)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                } header: {
                    sectionHeader(LocalizationConstants.ListDetails.activeSection)
                }
            }

            // Completed Items Section
            if !viewModel.completedItems.isEmpty {
                Section {
                    ForEach(viewModel.completedItems) { item in
                        itemRow(item)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                } header: {
                    sectionHeader(LocalizationConstants.ListDetails.completedSection)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.textSecondary)
            .textCase(nil)
            .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 8, trailing: 20))
    }

    private func itemRow(_ item: ProductItemDTO) -> some View {
        ProductItemRowView(
            item: item,
            onToggleCompleted: {
                viewModel.toggleItemCompleted(item)
            },
            onEdit: {
                viewModel.showEditItemSheet(item: item)
            }
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                viewModel.deleteItem(item)
            } label: {
                Label(LocalizationConstants.ListDetails.delete, systemImage: "trash")
                    .labelStyle(.iconOnly)
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                viewModel.showEditItemSheet(item: item)
            } label: {
                Label(LocalizationConstants.ListDetails.edit, systemImage: "pencil")
                    .labelStyle(.iconOnly)
            }
            .tint(Color(.primaryPurple))
        }
    }
}

#Preview {
    ListDetailsView(
        viewModel: ListDetailsViewModel(
            list: ProductsListDTO(
                id: 1,
                name: "Grocery Shopping",
                updatedDate: Date(),
                items: [
                    ProductItemDTO(title: "Milk", count: 2, price: 4.99, isCompleted: false),
                    ProductItemDTO(title: "Bread", count: 1, price: 3.49, isCompleted: true),
                    ProductItemDTO(title: "Eggs", count: 1, price: 5.99, isCompleted: false)
                ]
            ),
            coordinator: ListsCoordinator()
        )
    )
}
