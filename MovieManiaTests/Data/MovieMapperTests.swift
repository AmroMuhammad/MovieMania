//
//  MovieMapperTests.swift
//  MovieMania
//
//  Created by Amr Muhammad on 14/04/2026.
//

import Testing
import Foundation
import Networking
@testable import MovieMania

struct MovieMapperTests {
    private func decodeDTO(_ json: String) throws -> MovieDTO {
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(MovieDTO.self, from: data)
    }

    @Test func mapDTOToDomain() throws {
        let dto = try decodeDTO("""
        {
            "id": 1,
            "title": "Test Movie",
            "poster_path": "/poster.jpg",
            "release_date": "2024-05-15",
            "genre_ids": [28, 12],
            "overview": "Test overview",
            "vote_average": 7.5,
            "popularity": 100.0
        }
        """)

        let movie = MovieMapper.toDomain(dto)

        #expect(movie.id == 1)
        #expect(movie.title == "Test Movie")
        #expect(movie.posterPath == "/poster.jpg")
        #expect(movie.releaseDate == "2024-05-15")
        #expect(movie.genreIDs == [28, 12])
        #expect(movie.releaseYear == "2024")
    }

    @Test func mapDTOWithNilPosterPath() throws {
        let dto = try decodeDTO("""
        {
            "id": 2,
            "title": "No Poster",
            "poster_path": null,
            "release_date": null,
            "genre_ids": [],
            "overview": null,
            "vote_average": null,
            "popularity": null
        }
        """)

        let movie = MovieMapper.toDomain(dto)

        #expect(movie.posterPath == nil)
        #expect(movie.releaseDate == nil)
        #expect(movie.releaseYear == nil)
        #expect(movie.genreIDs.isEmpty)
    }

    @Test func mapMovieToEntityAndBack() {
        let movie = Movie(
            id: 1,
            title: "Test Movie",
            posterPath: "/poster.jpg",
            releaseDate: "2024-05-15",
            genreIDs: [28, 12]
        )

        let entity = MovieMapper.toEntity(movie, page: 2)

        #expect(entity.id == 1)
        #expect(entity.title == "Test Movie")
        #expect(entity.cachedPage == 2)

        let mappedBack = MovieMapper.toDomain(entity)

        #expect(mappedBack.id == movie.id)
        #expect(mappedBack.title == movie.title)
        #expect(mappedBack.posterPath == movie.posterPath)
        #expect(mappedBack.genreIDs == movie.genreIDs)
    }
}
