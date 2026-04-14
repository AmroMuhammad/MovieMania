//
//  Mocks.swift
//  MovieMania
//
//  Created by Amr Muhammad on 14/04/2026.
//

import Foundation
@testable import MovieMania

final class MockMovieRepository: MovieRepository, @unchecked Sendable {
    var stubbedTrendingResult: PaginatedResponse<Movie>?
    var stubbedDetailResult: MovieDetail?
    var stubbedError: Error?
    var getTrendingCallCount = 0
    var getDetailCallCount = 0

    func getTrendingMovies(page: Int) async throws -> PaginatedResponse<Movie> {
        getTrendingCallCount += 1
        if let error = stubbedError { throw error }
        return stubbedTrendingResult!
    }

    func getMovieDetail(id: Int) async throws -> MovieDetail {
        getDetailCallCount += 1
        if let error = stubbedError { throw error }
        return stubbedDetailResult!
    }
}

final class MockGenreRepository: GenreRepository, @unchecked Sendable {
    var stubbedGenres: [Genre] = []
    var stubbedError: Error?
    var getGenresCallCount = 0

    func getGenres() async throws -> [Genre] {
        getGenresCallCount += 1
        if let error = stubbedError { throw error }
        return stubbedGenres
    }
}

final class MockGetTrendingMoviesUseCase: GetTrendingMoviesUseCaseProtocol, @unchecked Sendable {
    var stubbedResult: PaginatedResponse<Movie>?
    var stubbedError: Error?

    func execute(page: Int) async throws -> PaginatedResponse<Movie> {
        if let error = stubbedError { throw error }
        return stubbedResult!
    }
}

final class MockGetMovieDetailUseCase: GetMovieDetailUseCaseProtocol, @unchecked Sendable {
    var stubbedResult: MovieDetail?
    var stubbedError: Error?

    func execute(id: Int) async throws -> MovieDetail {
        if let error = stubbedError { throw error }
        return stubbedResult!
    }
}

final class MockGetGenresUseCase: GetGenresUseCaseProtocol, @unchecked Sendable {
    var stubbedResult: [Genre] = []
    var stubbedError: Error?

    func execute() async throws -> [Genre] {
        if let error = stubbedError { throw error }
        return stubbedResult
    }
}
