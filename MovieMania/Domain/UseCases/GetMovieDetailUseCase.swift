//
//  GetMovieDetailUseCase.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Combine
import Foundation

protocol GetMovieDetailUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<MovieDetail, Error>
}

final class GetMovieDetailUseCase: GetMovieDetailUseCaseProtocol {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(id: Int) -> AnyPublisher<MovieDetail, Error> {
        repository.getMovieDetail(id: id)
    }
}
