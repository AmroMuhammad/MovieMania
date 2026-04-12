//
//  MovieDetailEntity.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import SwiftData

@Model
final class MovieDetailEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var posterPath: String?
    var releaseDate: String?
    var genreNames: [String]
    var genreIDs: [Int]
    var overview: String
    var homepage: String?
    var budget: Int
    var revenue: Int
    var spokenLanguages: [String]
    var status: String
    var runtime: Int?
    var cachedAt: Date

    init(
        id: Int,
        title: String,
        posterPath: String?,
        releaseDate: String?,
        genreNames: [String],
        genreIDs: [Int],
        overview: String,
        homepage: String?,
        budget: Int,
        revenue: Int,
        spokenLanguages: [String],
        status: String,
        runtime: Int?,
        cachedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genreNames = genreNames
        self.genreIDs = genreIDs
        self.overview = overview
        self.homepage = homepage
        self.budget = budget
        self.revenue = revenue
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.runtime = runtime
        self.cachedAt = cachedAt
    }
}
