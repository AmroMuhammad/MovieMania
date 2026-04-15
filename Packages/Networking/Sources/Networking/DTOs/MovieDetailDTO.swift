//
//  MovieDetailDTO.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public struct MovieDetailDTO: Decodable, Sendable {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let releaseDate: String?
    public let genres: [GenreDTO]
    public let overview: String
    public let homepage: String?
    public let budget: Int
    public let revenue: Int
    public let spokenLanguages: [SpokenLanguageDTO]
    public let status: String
    public let runtime: Int?
}

public struct SpokenLanguageDTO: Decodable, Sendable {
    public let englishName: String
    public let name: String
}
