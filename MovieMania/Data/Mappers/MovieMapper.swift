//
//  MovieMapper.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Networking

enum MovieMapper {
    static func toDomain(_ dto: MovieDTO) -> Movie {
        Movie(
            id: dto.id,
            title: dto.title,
            posterPath: dto.posterPath,
            releaseDate: dto.releaseDate,
            genreIDs: dto.genreIds
        )
    }

    static func toDomain(_ entity: MovieEntity) -> Movie {
        Movie(
            id: entity.id,
            title: entity.title,
            posterPath: entity.posterPath,
            releaseDate: entity.releaseDate,
            genreIDs: entity.genreIDs
        )
    }

    static func toEntity(_ movie: Movie, page: Int) -> MovieEntity {
        MovieEntity(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            releaseDate: movie.releaseDate,
            genreIDs: movie.genreIDs,
            cachedPage: page
        )
    }
}
