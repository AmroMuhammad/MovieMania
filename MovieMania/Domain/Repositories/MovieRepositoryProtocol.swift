//
//  MovieRepositoryProtocol.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Foundation

protocol MovieRepository: Sendable {
    func getTrendingMovies(page: Int) async throws -> PaginatedResponse<Movie>
    func getMovieDetail(id: Int) async throws -> MovieDetail
}
