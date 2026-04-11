//
//  GetTrendingMoviesUseCase.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Foundation

protocol GetTrendingMoviesUseCaseProtocol: Sendable {
    func execute(page: Int) async throws -> PaginatedResponse<Movie>
}

final class GetTrendingMoviesUseCase: GetTrendingMoviesUseCaseProtocol {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> PaginatedResponse<Movie> {
        try await repository.getTrendingMovies(page: page)
    }
}
