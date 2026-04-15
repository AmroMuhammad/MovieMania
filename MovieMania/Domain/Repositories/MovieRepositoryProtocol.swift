//
//  MovieRepositoryProtocol.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Combine
import Foundation

protocol MovieRepository {
    func getTrendingMovies(page: Int) -> AnyPublisher<PaginatedResponse<Movie>, Error>
    func getMovieDetail(id: Int) -> AnyPublisher<MovieDetail, Error>
}
