//
//  RemoteGenreDataSource.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import Networking

final class RemoteGenreDataSource: Sendable {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func fetchGenres() async throws -> GenreListResponseDTO {
        try await client.request(
            MovieEndpoint.genres,
            responseType: GenreListResponseDTO.self
        )
    }
}
