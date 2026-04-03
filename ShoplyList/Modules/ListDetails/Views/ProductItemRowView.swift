//
//  ProductItemRowView.swift
//  ShoplyList
//
//  Created on 12.02.2026.
//  Copyright (c) 2026 Shoply. All rights reserved.
//

import SwiftUI

struct ProductItemRowView: View {
    let item: ProductItemDTO
    let onToggleCompleted: () -> Void
    let onEdit: () -> Void

    private var formattedPrice: String {
        String(format: "$%.2f", item.price * Double(item.count))
    }

    private var unitPrice: String {
        String(format: "$%.2f", item.price)
    }

    var body: some View {
        HStack(spacing: 12) {
            checkboxView
            itemInfoView
            Spacer(minLength: 0)
            priceView
        }
        .padding(16)
        .background(backgroundView)
        .contentShape(Rectangle())
        .onTapGesture {
            onEdit()
        }
    }
}

// MARK: - UI Components
extension ProductItemRowView {
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.cardBackground))
            .shadow(color: Color(.cardShadow), radius: 8, y: 2)
    }

    private var checkboxView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(
                    item.isCompleted
                    ? Color(.primaryPurple)
                    : Color(.primaryPurple).opacity(0.4),
                    lineWidth: 2
                )
                .frame(width: 24, height: 24)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            item.isCompleted
                            ? Color(.primaryPurple)
                            : Color.clear
                        )
                )

            if item.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .onTapGesture {
            onToggleCompleted()
        }
    }

    private var itemInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(
                    item.isCompleted
                        ? Color(.textSecondary)
                        : Color(.textPrimary)
                )
                .strikethrough(item.isCompleted, color: .textSecondary)
                .lineLimit(1)

            HStack(spacing: 8) {
                quantityBadge
                if item.price > 0 {
                    unitPriceView
                }
            }
        }
    }

    private var quantityBadge: some View {
        HStack(spacing: 2) {
            Image(systemName: "number")
                .font(.system(size: 10, weight: .medium))
            Text("\(item.count)")
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundStyle(Color(.primaryPurple))
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.primaryPurple).opacity(0.1))
        )
    }

    private var unitPriceView: some View {
        Text("\(unitPrice) each")
            .font(.system(size: 12))
            .foregroundStyle(.textSecondary)
    }

    @ViewBuilder
    private var priceView: some View {
        if item.price > 0 {
            Text(formattedPrice)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(
                    item.isCompleted
                        ? Color(.textSecondary)
                        : Color(.primaryPurple)
                )
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        ProductItemRowView(
            item: ProductItemDTO(
                title: "Organic Milk",
                count: 2,
                price: 4.99,
                isCompleted: false
            ),
            onToggleCompleted: {},
            onEdit: {}
        )

        ProductItemRowView(
            item: ProductItemDTO(
                title: "Whole Wheat Bread",
                count: 1,
                price: 3.49,
                isCompleted: true
            ),
            onToggleCompleted: {},
            onEdit: {}
        )
    }
    .padding()
    .background(Color(.backgroundGradientTop))
}
