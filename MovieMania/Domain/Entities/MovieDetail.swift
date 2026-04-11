//
//  MovieDetail.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Foundation

struct MovieDetail: Sendable, Identifiable, Equatable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String?
    let genres: [Genre]
    let overview: String
    let homepage: String?
    let budget: Int
    let revenue: Int
    let spokenLanguages: [String]
    let status: String
    let runtime: Int?

    init(
        id: Int,
        title: String,
        posterPath: String?,
        releaseDate: String?,
        genres: [Genre],
        overview: String,
        homepage: String?,
        budget: Int,
        revenue: Int,
        spokenLanguages: [String],
        status: String,
        runtime: Int?
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genres = genres
        self.overview = overview
        self.homepage = homepage
        self.budget = budget
        self.revenue = revenue
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.runtime = runtime
    }

    var releaseYear: String? {
        guard let releaseDate, releaseDate.count >= 4 else { return nil }
        return String(releaseDate.prefix(4))
    }

    var releaseYearMonth: String? {
        guard let releaseDate, releaseDate.count >= 7 else { return nil }
        return String(releaseDate.prefix(7))
    }
}
