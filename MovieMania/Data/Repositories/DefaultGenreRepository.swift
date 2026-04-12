//
//  DefaultGenreRepository.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import Networking

final class DefaultGenreRepository: GenreRepository, @unchecked Sendable {
    private let remote: RemoteGenreDataSource
    private let local: LocalGenreDataSource

    init(remote: RemoteGenreDataSource, local: LocalGenreDataSource) {
        self.remote = remote
        self.local = local
    }

    func getGenres() async throws -> [Genre] {
        do {
            let response = try await remote.fetchGenres()
            let genres = response.genres.map(GenreMapper.toDomain)
            let entities = genres.map(GenreMapper.toEntity)
            try await MainActor.run {
                try local.saveGenres(entities)
            }
            return genres
        } catch {
            let genres = try await MainActor.run {
                let cached = try local.getGenres()
                return cached.map(GenreMapper.toDomain)
            }
            if genres.isEmpty { throw error }
            return genres
        }
    }
}
