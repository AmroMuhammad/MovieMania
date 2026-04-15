//
//  DependencyContainer.swift
//  MovieMania
//
//  Created by Amr Muhammad on 13/04/2026.
//

import Foundation
import SwiftData
import Networking

@MainActor
final class DependencyContainer {
    // MARK: - SwiftData
    let modelContainer: ModelContainer

    // MARK: - Configuration
    let apiConfiguration: APIConfiguration

    var imageBaseURL: String { apiConfiguration.imageBaseURL }

    // MARK: - Networking
    private lazy var httpClient: HTTPClient = URLSessionHTTPClient(configuration: apiConfiguration)

    // MARK: - Remote Data Sources
    private lazy var remoteMovieDataSource = RemoteMovieDataSource(client: httpClient)
    private lazy var remoteGenreDataSource = RemoteGenreDataSource(client: httpClient)

    // MARK: - Local Data Sources
    private lazy var localMovieDataSource = LocalMovieDataSource(modelContainer: modelContainer)
    private lazy var localGenreDataSource = LocalGenreDataSource(modelContainer: modelContainer)

    // MARK: - Repositories
    private lazy var movieRepository: MovieRepository = DefaultMovieRepository(
        remote: remoteMovieDataSource,
        local: localMovieDataSource
    )
    private lazy var genreRepository: GenreRepository = DefaultGenreRepository(
        remote: remoteGenreDataSource,
        local: localGenreDataSource
    )

    // MARK: - Use Cases
    private lazy var getTrendingMoviesUseCase: GetTrendingMoviesUseCaseProtocol = GetTrendingMoviesUseCase(
        repository: movieRepository
    )
    private lazy var getMovieDetailUseCase: GetMovieDetailUseCaseProtocol = GetMovieDetailUseCase(
        repository: movieRepository
    )
    private lazy var getGenresUseCase: GetGenresUseCaseProtocol = GetGenresUseCase(
        repository: genreRepository
    )

    // MARK: - Init
    init() {
        self.apiConfiguration = APIConfiguration(apiKey: Secrets.tmdbAPIKey)

        do {
            self.modelContainer = try ModelContainer(
                for: MovieEntity.self, MovieDetailEntity.self, GenreEntity.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    // MARK: - Factory Methods
    func makeMovieListViewModel() -> MovieListViewModel {
        MovieListViewModel(
            getTrendingMovies: getTrendingMoviesUseCase,
            getGenres: getGenresUseCase
        )
    }

    func makeMovieDetailViewModel(movieID: Int) -> MovieDetailViewModel {
        MovieDetailViewModel(
            movieID: movieID,
            getMovieDetail: getMovieDetailUseCase
        )
    }
}
