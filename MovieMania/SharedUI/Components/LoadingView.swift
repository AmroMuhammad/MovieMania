//
//  LoadingView.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import SwiftUI

struct LoadingView: View {
    private let message: String?

    init(message: String? = nil) {
        self.message = message
    }

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
            if let message {
                Text(message)
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.secondaryLabel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
