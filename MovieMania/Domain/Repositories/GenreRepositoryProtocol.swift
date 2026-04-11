//
//  GenreRepositoryProtocol.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Foundation

protocol GenreRepository: Sendable {
    func getGenres() async throws -> [Genre]
}
