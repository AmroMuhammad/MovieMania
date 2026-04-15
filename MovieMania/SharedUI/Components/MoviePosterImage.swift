//
//  MoviePosterImage.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import SwiftUI

struct MoviePosterImage: View {
    private let url: URL?

    init(url: URL?) {
        self.url = url
    }

    var body: some View {
        CachedAsyncImage(url: url)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.posterCornerRadius))
    }
}
