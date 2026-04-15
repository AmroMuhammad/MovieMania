//
//  GenreChipView.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import SwiftUI

struct GenreChipView: View {
    private let title: String
    private let isSelected: Bool
    private let action: () -> Void

    init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.caption)
                .fontWeight(.medium)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AppColors.chipSelected : AppColors.chipUnselected)
                .foregroundStyle(isSelected ? AppColors.chipTextSelected : AppColors.chipTextUnselected)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
