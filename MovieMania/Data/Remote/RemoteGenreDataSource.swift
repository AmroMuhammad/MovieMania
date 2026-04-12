//
//  RemoteGenreDataSource.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Combine
import Foundation
import Networking

final class RemoteGenreDataSource {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func fetchGenres() -> AnyPublisher<GenreListResponseDTO, APIError> {
        client.requestPublisher(
            MovieEndpoint.genres,
            responseType: GenreListResponseDTO.self
        )
    }
}
