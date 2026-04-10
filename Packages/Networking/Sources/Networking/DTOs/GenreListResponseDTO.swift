//
//  GenreListResponseDTO.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public struct GenreListResponseDTO: Decodable, Sendable {
    public let genres: [GenreDTO]
}
