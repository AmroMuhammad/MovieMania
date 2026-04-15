//
//  DefaultMovieRepository.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Combine
import Foundation
import Networking

final class DefaultMovieRepository: MovieRepository {
    private let remote: RemoteMovieDataSource
    private let local: LocalMovieDataSource

    init(remote: RemoteMovieDataSource, local: LocalMovieDataSource) {
        self.remote = remote
        self.local = local
    }

    func getTrendingMovies(page: Int) -> AnyPublisher<PaginatedResponse<Movie>, Error> {
        let local = self.local
        return remote.fetchTrendingMovies(page: page)
            .map { response -> PaginatedResponse<Movie> in
                let movies = response.results.map { MovieMapper.toDomain($0) }
                return PaginatedResponse(
                    results: movies,
                    page: response.page,
                    totalPages: response.totalPages
                )
            }
            .mapError { $0 as Error }
            .flatMap { response -> AnyPublisher<PaginatedResponse<Movie>, Error> in
                local.saveMovies(response.results, page: page)
                    .map { response }
                    .catch { _ in Just(response).setFailureType(to: Error.self) }
                    .eraseToAnyPublisher()
            }
            .catch { error -> AnyPublisher<PaginatedResponse<Movie>, Error> in
                local.getMovies(page: page)
                    .tryMap { movies in
                        guard !movies.isEmpty else { throw error }
                        return PaginatedResponse(results: movies, page: page, totalPages: page)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func getMovieDetail(id: Int) -> AnyPublisher<MovieDetail, Error> {
        let local = self.local
        return remote.fetchMovieDetail(id: id)
            .map { MovieDetailMapper.toDomain($0) }
            .mapError { $0 as Error }
            .flatMap { detail -> AnyPublisher<MovieDetail, Error> in
                local.saveMovieDetail(detail)
                    .map { detail }
                    .catch { _ in Just(detail).setFailureType(to: Error.self) }
                    .eraseToAnyPublisher()
            }
            .catch { error -> AnyPublisher<MovieDetail, Error> in
                local.getMovieDetail(id: id)
                    .tryMap { cached in
                        guard let cached else { throw error }
                        return cached
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
