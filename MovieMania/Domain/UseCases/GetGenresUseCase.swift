//
//  GetGenresUseCase.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Combine
import Foundation

protocol GetGenresUseCaseProtocol {
    func execute() -> AnyPublisher<[Genre], Error>
}

final class GetGenresUseCase: GetGenresUseCaseProtocol {
    private let repository: GenreRepository

    init(repository: GenreRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[Genre], Error> {
        repository.getGenres()
    }
}
