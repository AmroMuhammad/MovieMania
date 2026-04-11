//
//  GenreChipsScrollView.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import SwiftUI

struct GenreChipItem: Identifiable, Sendable {
    let id: Int
    let name: String
    let isSelected: Bool

    init(id: Int, name: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}

struct GenreChipsScrollView: View {
    private let chips: [GenreChipItem]
    private let onSelect: (Int) -> Void

    init(chips: [GenreChipItem], onSelect: @escaping (Int) -> Void) {
        self.chips = chips
        self.onSelect = onSelect
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(chips) { chip in
                    GenreChipView(
                        title: chip.name,
                        isSelected: chip.isSelected
                    ) {
                        onSelect(chip.id)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }
}
