//
//  GenreRepositoryProtocol.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Combine
import Foundation

protocol GenreRepository {
    func getGenres() -> AnyPublisher<[Genre], Error>
}
