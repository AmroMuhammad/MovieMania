//
//  CachedAsyncImage.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Combine
import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    @State private var image: UIImage?
    @State private var hasFailed = false
    @State private var cancellable: AnyCancellable?

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
        .onAppear { load(url: url) }
        .onChange(of: url) { _, newURL in load(url: newURL) }
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

    private func load(url: URL?) {
        cancellable?.cancel()
        image = nil
        hasFailed = false

        guard let url else {
            hasFailed = true
            return
        }

        if let cached = ImageCache.shared.image(for: url) {
            image = cached
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap(UIImage.init(data:))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        hasFailed = true
                    }
                },
                receiveValue: { uiImage in
                    ImageCache.shared.store(uiImage, for: url)
                    image = uiImage
                }
            )
    }
}
