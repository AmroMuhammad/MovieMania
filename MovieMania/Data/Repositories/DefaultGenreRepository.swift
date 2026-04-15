//
//  DefaultGenreRepository.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Combine
import Foundation
import Networking

final class DefaultGenreRepository: GenreRepository {
    private let remote: RemoteGenreDataSource
    private let local: LocalGenreDataSource

    init(remote: RemoteGenreDataSource, local: LocalGenreDataSource) {
        self.remote = remote
        self.local = local
    }

    func getGenres() -> AnyPublisher<[Genre], Error> {
        let local = self.local
        return remote.fetchGenres()
            .map { $0.genres.map { GenreMapper.toDomain($0) } }
            .mapError { $0 as Error }
            .flatMap { genres -> AnyPublisher<[Genre], Error> in
                local.saveGenres(genres)
                    .map { genres }
                    .catch { _ in Just(genres).setFailureType(to: Error.self) }
                    .eraseToAnyPublisher()
            }
            .catch { error -> AnyPublisher<[Genre], Error> in
                local.getGenres()
                    .tryMap { genres in
                        guard !genres.isEmpty else { throw error }
                        return genres
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
