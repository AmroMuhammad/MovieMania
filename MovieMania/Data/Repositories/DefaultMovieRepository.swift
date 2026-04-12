//
//  DefaultMovieRepository.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import Networking

final class DefaultMovieRepository: MovieRepository, @unchecked Sendable {
    private let remote: RemoteMovieDataSource
    private let local: LocalMovieDataSource

    init(remote: RemoteMovieDataSource, local: LocalMovieDataSource) {
        self.remote = remote
        self.local = local
    }

    func getTrendingMovies(page: Int) async throws -> PaginatedResponse<Movie> {
        do {
            let response = try await remote.fetchTrendingMovies(page: page)
            let movies = response.results.map(MovieMapper.toDomain)
            let entities = movies.map { MovieMapper.toEntity($0, page: page) }
            try await MainActor.run {
                try local.saveMovies(entities)
            }
            return PaginatedResponse(
                results: movies,
                page: response.page,
                totalPages: response.totalPages
            )
        } catch {
            let movies = try await MainActor.run {
                let cached = try local.getMovies(page: page)
                return cached.map(MovieMapper.toDomain)
            }
            if movies.isEmpty { throw error }
            return PaginatedResponse(results: movies, page: page, totalPages: page)
        }
    }

    func getMovieDetail(id: Int) async throws -> MovieDetail {
        do {
            let dto = try await remote.fetchMovieDetail(id: id)
            let detail = MovieDetailMapper.toDomain(dto)
            let entity = MovieDetailMapper.toEntity(detail)
            try await MainActor.run {
                try local.saveMovieDetail(entity)
            }
            return detail
        } catch {
            let detail = try await MainActor.run {
                guard let cached = try local.getMovieDetail(id: id) else {
                    return nil as MovieDetail?
                }
                return MovieDetailMapper.toDomain(cached)
            }
            guard let detail else { throw error }
            return detail
        }
    }
}
