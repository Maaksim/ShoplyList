//
//  AllListsView.swift
//  ShoplyList
//
//  Created by Maksym Vitovych on 29.01.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import SwiftUI

struct AllListsView: View {
    @State private var viewModel: AllListsViewModel

    init(viewModel: AllListsViewModel) {
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
        .onAppear {
            viewModel.onAppear()
        }
    }

    private var addButton: some View {
        Button(action: viewModel.showAddListSheet) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
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
                .shadow(color: Color(.primaryPurple).opacity(0.4), radius: 8, y: 4)
        }
    }
}

// MARK: - UI components
extension AllListsView {
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
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                titleView
                listsCountView
            }

            Spacer(minLength: 0)
            addButton
        }
        .padding([.horizontal, .bottom], 20)
        .padding(.top, 16)
    }

    private var titleView: some View {
        Text(LocalizationConstants.AllLists.title)
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(Color(.textPrimary))
    }

    private var listsCountView: some View {
        Text(LocalizationConstants.AllLists.listsCount(viewModel.lists.count))
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.textSecondary)
    }

    // MARK: - Content
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if let error = viewModel.errorMessage {
            errorView(error)
        } else if viewModel.lists.isEmpty {
            emptyStateView
        } else {
            listView
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer(minLength: 0)
            ProgressView()
                .scaleEffect(1.2)
            Spacer(minLength: 0)
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Spacer(minLength: 0)
            errorIcon
            errorText(message)
            retryButton
            Spacer(minLength: 0)
        }
        .padding()
    }

    private var errorIcon: some View {
        Image(systemName: "exclamationmark.triangle")
            .font(.system(size: 48))
            .foregroundStyle(.orange)
    }

    private func errorText(_ message: String) -> some View {
        Text(message)
            .font(.subheadline)
            .foregroundStyle(.textSecondary)
            .multilineTextAlignment(.center)
    }

    private var retryButton: some View {
        Button(LocalizationConstants.AllLists.retry) {
            viewModel.fetchLists()
        }
        .buttonStyle(.borderedProminent)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 0)
            emptyStateImageView
            noListsTitle
            emptyStateMessage
            Spacer(minLength: 0)
        }
        .padding()
    }

    private var emptyStateImageView: some View {
        Image(systemName: "cart")
            .font(.system(size: 64))
            .foregroundStyle(Color(.primaryPurple).opacity(0.6))
    }

    private var noListsTitle: some View {
        Text(LocalizationConstants.AllLists.noLists)
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(Color(.textPrimary))
    }

    private var emptyStateMessage: some View {
        Text(LocalizationConstants.AllLists.emptyStateMessage)
            .font(.system(size: 15))
            .foregroundStyle(.textSecondary)
            .multilineTextAlignment(.center)
    }

    private var listView: some View {
        List {
            ForEach(viewModel.lists) { list in
                listRowItem(list)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func listRowItem(_ list: ProductsListDTO) -> some View {
        ListRowView(list: list) {
            viewModel.selectList(list)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                viewModel.deleteList(list)
            } label: {
                Label(LocalizationConstants.AllLists.delete,
                      systemImage: "trash")
                .labelStyle(.iconOnly)
            }
        }
    }
}

#Preview {
    AllListsView(viewModel: AllListsViewModel(
        coordinator: ListsCoordinator()
    ))
}
