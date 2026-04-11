//
//  GetMovieDetailUseCase.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Foundation

protocol GetMovieDetailUseCaseProtocol: Sendable {
    func execute(id: Int) async throws -> MovieDetail
}

final class GetMovieDetailUseCase: GetMovieDetailUseCaseProtocol {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> MovieDetail {
        try await repository.getMovieDetail(id: id)
    }
}
