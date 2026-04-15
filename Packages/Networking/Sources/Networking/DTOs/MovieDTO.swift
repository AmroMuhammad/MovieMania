//
//  MovieDTO.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public struct MovieDTO: Decodable, Sendable {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let releaseDate: String?
    public let genreIds: [Int]
    public let overview: String?
    public let voteAverage: Double?
    public let popularity: Double?
}
