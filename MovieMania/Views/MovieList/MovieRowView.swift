//
//  MovieRowView.swift
//  MovieMania
//
//  Created by Amr Muhammad on 13/04/2026.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    let imageBaseURL: String

    private var posterURL: URL? {
        guard let posterPath = movie.posterPath else { return nil }
        return URL(string: "\(imageBaseURL)/w500\(posterPath)")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            MoviePosterImage(url: posterURL)
                .aspectRatio(2/3, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .clipped()

            Text(movie.title)
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.label)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(minHeight: 36, alignment: .topLeading)

            Text(movie.releaseYear ?? "—")
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.secondaryLabel)
        }
    }
}
