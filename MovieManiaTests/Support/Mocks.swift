//
//  Mocks.swift
//  MovieMania
//
//  Created by Amr Muhammad on 14/04/2026.
//

import Combine
import Foundation
@testable import MovieMania

final class MockMovieRepository: MovieRepository {
    var stubbedTrendingResult: PaginatedResponse<Movie>?
    var stubbedDetailResult: MovieDetail?
    var stubbedError: Error?
    var getTrendingCallCount = 0
    var getDetailCallCount = 0

    func getTrendingMovies(page: Int) -> AnyPublisher<PaginatedResponse<Movie>, Error> {
        getTrendingCallCount += 1
        if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(stubbedTrendingResult!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getMovieDetail(id: Int) -> AnyPublisher<MovieDetail, Error> {
        getDetailCallCount += 1
        if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(stubbedDetailResult!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class MockGenreRepository: GenreRepository {
    var stubbedGenres: [Genre] = []
    var stubbedError: Error?
    var getGenresCallCount = 0

    func getGenres() -> AnyPublisher<[Genre], Error> {
        getGenresCallCount += 1
        if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(stubbedGenres)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class MockGetTrendingMoviesUseCase: GetTrendingMoviesUseCaseProtocol {
    var stubbedResult: PaginatedResponse<Movie>?
    var stubbedError: Error?

    func execute(page: Int) -> AnyPublisher<PaginatedResponse<Movie>, Error> {
        if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(stubbedResult!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class MockGetMovieDetailUseCase: GetMovieDetailUseCaseProtocol {
    var stubbedResult: MovieDetail?
    var stubbedError: Error?

    func execute(id: Int) -> AnyPublisher<MovieDetail, Error> {
        if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(stubbedResult!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class MockGetGenresUseCase: GetGenresUseCaseProtocol {
    var stubbedResult: [Genre] = []
    var stubbedError: Error?

    func execute() -> AnyPublisher<[Genre], Error> {
        if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(stubbedResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
