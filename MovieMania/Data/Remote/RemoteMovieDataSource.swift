//
//  RemoteMovieDataSource.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import Networking

final class RemoteMovieDataSource: Sendable {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func fetchTrendingMovies(page: Int) async throws -> PaginatedResponseDTO<MovieDTO> {
        try await client.request(
            MovieEndpoint.trending(page: page),
            responseType: PaginatedResponseDTO<MovieDTO>.self
        )
    }

    func fetchMovieDetail(id: Int) async throws -> MovieDetailDTO {
        try await client.request(
            MovieEndpoint.movieDetail(id: id),
            responseType: MovieDetailDTO.self
        )
    }
}
