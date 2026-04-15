//
//  RemoteMovieDataSource.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Combine
import Foundation
import Networking

final class RemoteMovieDataSource {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func fetchTrendingMovies(page: Int) -> AnyPublisher<PaginatedResponseDTO<MovieDTO>, APIError> {
        client.requestPublisher(
            MovieEndpoint.trending(page: page),
            responseType: PaginatedResponseDTO<MovieDTO>.self
        )
    }

    func fetchMovieDetail(id: Int) -> AnyPublisher<MovieDetailDTO, APIError> {
        client.requestPublisher(
            MovieEndpoint.movieDetail(id: id),
            responseType: MovieDetailDTO.self
        )
    }
}
