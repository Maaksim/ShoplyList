//
//  ListRowView.swift
//  ShoplyList
//
//  Created on 11.02.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import SwiftUI

struct ListRowView: View {
    let list: ProductsListDTO
    let onTap: () -> Void

    private var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: list.updatedDate, relativeTo: Date())
    }

    private var itemsCountText: String {
        let count = list.items.count
        return count == 1
            ? LocalizationConstants.AllLists.oneItem
            : LocalizationConstants.AllLists.itemsCount(count)
    }

    private var completedCount: Int {
        list.items.filter(\.isCompleted).count
    }

    private var progress: Double {
        guard !list.items.isEmpty else { return 0 }
        return Double(completedCount) / Double(list.items.count)
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                listIconView
                listInfoView
                Spacer(minLength: 0)
                progressIndicator
                arrowView
            }
            .padding(16)
            .background(backgroundView)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - UI components
extension ListRowView {
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.cardBackground))
            .shadow(color: Color(.cardShadow), radius: 12, y: 4)
    }

    private var listInfoView: some View {
        VStack(alignment: .leading, spacing: 6) {
            listTitle

            HStack(spacing: 12) {
                itemsCountView
                dateView
            }
        }
    }

    private var listTitle: some View {
        Text(list.name)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Color(.textPrimary))
            .lineLimit(1)
    }

    private var itemsCountView: some View {
        HStack(spacing: 4) {
            Image(systemName: "cart")
                .foregroundStyle(.textSecondary)

            Text(itemsCountText)
                .font(.system(size: 13))
                .foregroundStyle(.textSecondary)
        }
    }

    private var dateView: some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .foregroundStyle(.textSecondary)

            Text(formattedDate)
                .font(.system(size: 13))
                .foregroundStyle(.textSecondary)
        }
    }

    @ViewBuilder
    private var progressIndicator: some View {
        if !list.items.isEmpty {
            ZStack {
                Circle()
                    .stroke(Color(.primaryPurple).opacity(0.2),
                            lineWidth: 3)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color(.primaryPurple),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                Text("\(Int(progress * 100))%")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color(.primaryPurple))
            }
            .frame(width: 40, height: 40)
        }
    }

    private var arrowView: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(Color(.primaryPurple))
    }

    private var listIconBackground: some View {
        RoundedRectangle(cornerRadius: 12)
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
            .frame(width: 48, height: 48)
    }

    private var listIconImage: some View {
        Image(systemName: "list.bullet")
            .font(.system(size: 20, weight: .medium))
            .foregroundStyle(Color(.primaryPurple))
    }

    private var listIconView: some View {
        ZStack {
            listIconBackground
            listIconImage
        }
    }
}

#Preview {
    ListRowView(
        list: ProductsListDTO(
            id: 1,
            name: "Grocery Shopping",
            updatedDate: Date(),
            items: [
                ProductItemDTO(title: "Milk", isCompleted: true),
                ProductItemDTO(title: "Bread", isCompleted: false)
            ]
        ),
        onTap: {}
    )
    .padding()
}
