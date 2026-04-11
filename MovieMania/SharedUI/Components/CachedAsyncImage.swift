//
//  CachedAsyncImage.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    @State private var image: UIImage?
    @State private var isLoading = true
    @State private var hasFailed = false

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if hasFailed {
                imagePlaceholder(icon: "film")
            } else {
                imagePlaceholder(icon: nil)
                    .overlay { ProgressView() }
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }

    @ViewBuilder
    private func imagePlaceholder(icon: String?) -> some View {
        Rectangle()
            .fill(AppColors.secondaryBackground)
            .overlay {
                if let icon {
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .foregroundStyle(AppColors.secondary)
                }
            }
    }

    private func loadImage() async {
        guard let url else {
            hasFailed = true
            return
        }

        if let cached = ImageCache.shared.image(for: url) {
            self.image = cached
            self.isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else {
                hasFailed = true
                return
            }
            ImageCache.shared.store(uiImage, for: url)
            self.image = uiImage
        } catch {
            hasFailed = true
        }
        isLoading = false
    }
}
