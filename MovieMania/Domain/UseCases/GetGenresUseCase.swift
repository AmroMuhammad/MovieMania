//
//  GetGenresUseCase.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Foundation

protocol GetGenresUseCaseProtocol: Sendable {
    func execute() async throws -> [Genre]
}

final class GetGenresUseCase: GetGenresUseCaseProtocol {
    private let repository: GenreRepository

    init(repository: GenreRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Genre] {
        try await repository.getGenres()
    }
}
