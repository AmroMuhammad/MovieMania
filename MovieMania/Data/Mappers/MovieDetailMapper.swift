//
//  MovieDetailMapper.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Networking

enum MovieDetailMapper {
    static func toDomain(_ dto: MovieDetailDTO) -> MovieDetail {
        MovieDetail(
            id: dto.id,
            title: dto.title,
            posterPath: dto.posterPath,
            releaseDate: dto.releaseDate,
            genres: dto.genres.map { Genre(id: $0.id, name: $0.name) },
            overview: dto.overview,
            homepage: dto.homepage,
            budget: dto.budget,
            revenue: dto.revenue,
            spokenLanguages: dto.spokenLanguages.map(\.englishName),
            status: dto.status,
            runtime: dto.runtime
        )
    }

    static func toDomain(_ entity: MovieDetailEntity) -> MovieDetail {
        let genres = zip(entity.genreIDs, entity.genreNames).map { Genre(id: $0, name: $1) }
        return MovieDetail(
            id: entity.id,
            title: entity.title,
            posterPath: entity.posterPath,
            releaseDate: entity.releaseDate,
            genres: genres,
            overview: entity.overview,
            homepage: entity.homepage,
            budget: entity.budget,
            revenue: entity.revenue,
            spokenLanguages: entity.spokenLanguages,
            status: entity.status,
            runtime: entity.runtime
        )
    }

    static func toEntity(_ detail: MovieDetail) -> MovieDetailEntity {
        MovieDetailEntity(
            id: detail.id,
            title: detail.title,
            posterPath: detail.posterPath,
            releaseDate: detail.releaseDate,
            genreNames: detail.genres.map(\.name),
            genreIDs: detail.genres.map(\.id),
            overview: detail.overview,
            homepage: detail.homepage,
            budget: detail.budget,
            revenue: detail.revenue,
            spokenLanguages: detail.spokenLanguages,
            status: detail.status,
            runtime: detail.runtime
        )
    }
}
