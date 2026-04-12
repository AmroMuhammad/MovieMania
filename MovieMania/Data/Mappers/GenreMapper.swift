//
//  GenreMapper.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Networking

enum GenreMapper {
    static func toDomain(_ dto: GenreDTO) -> Genre {
        Genre(id: dto.id, name: dto.name)
    }

    static func toDomain(_ entity: GenreEntity) -> Genre {
        Genre(id: entity.id, name: entity.name)
    }

    static func toEntity(_ genre: Genre) -> GenreEntity {
        GenreEntity(id: genre.id, name: genre.name)
    }
}
