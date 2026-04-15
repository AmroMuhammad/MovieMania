//
//  MovieEntity.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import SwiftData

@Model
final class MovieEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var posterPath: String?
    var releaseDate: String?
    var genreIDs: [Int]
    var cachedPage: Int
    var cachedAt: Date

    init(
        id: Int,
        title: String,
        posterPath: String?,
        releaseDate: String?,
        genreIDs: [Int],
        cachedPage: Int,
        cachedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genreIDs = genreIDs
        self.cachedPage = cachedPage
        self.cachedAt = cachedAt
    }
}
