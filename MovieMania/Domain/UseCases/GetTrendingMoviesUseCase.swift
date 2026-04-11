//
//  GetTrendingMoviesUseCase.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Combine
import Foundation

protocol GetTrendingMoviesUseCaseProtocol {
    func execute(page: Int) -> AnyPublisher<PaginatedResponse<Movie>, Error>
}

final class GetTrendingMoviesUseCase: GetTrendingMoviesUseCaseProtocol {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(page: Int) -> AnyPublisher<PaginatedResponse<Movie>, Error> {
        repository.getTrendingMovies(page: page)
    }
}
