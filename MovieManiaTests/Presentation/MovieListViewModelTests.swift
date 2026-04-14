//
//  MovieListViewModelTests.swift
//  MovieMania
//
//  Created by Amr Muhammad on 14/04/2026.
//

import Testing
import Foundation
@testable import MovieMania

@MainActor
struct MovieListViewModelTests {
    @Test func loadInitialPopulatesMoviesAndGenres() async {
        let mockMovies = MockGetTrendingMoviesUseCase()
        let mockGenres = MockGetGenresUseCase()

        mockMovies.stubbedResult = PaginatedResponse(
            results: [
                Movie(id: 1, title: "Movie 1", posterPath: nil, releaseDate: "2024-01-01", genreIDs: [28]),
                Movie(id: 2, title: "Movie 2", posterPath: nil, releaseDate: "2023-06-15", genreIDs: [35])
            ],
            page: 1,
            totalPages: 3
        )
        mockGenres.stubbedResult = [
            Genre(id: 28, name: "Action"),
            Genre(id: 35, name: "Comedy")
        ]

        let viewModel = MovieListViewModel(getTrendingMovies: mockMovies, getGenres: mockGenres)
        await viewModel.loadInitial()

        #expect(viewModel.movies.count == 2)
        #expect(viewModel.genres.count == 2)
        #expect(viewModel.hasMorePages == true)
        #expect(viewModel.isLoading == false)
    }

    @Test func toggleGenreSelectsAndDeselects() async {
        let mockMovies = MockGetTrendingMoviesUseCase()
        let mockGenres = MockGetGenresUseCase()
        mockMovies.stubbedResult = PaginatedResponse(results: [], page: 1, totalPages: 1)
        mockGenres.stubbedResult = []

        let viewModel = MovieListViewModel(getTrendingMovies: mockMovies, getGenres: mockGenres)
        let genre = Genre(id: 28, name: "Action")

        viewModel.toggleGenre(genre)
        #expect(viewModel.selectedGenre == genre)

        viewModel.toggleGenre(genre)
        #expect(viewModel.selectedGenre == nil)
    }

    @Test func errorStateOnLoadFailure() async {
        let mockMovies = MockGetTrendingMoviesUseCase()
        let mockGenres = MockGetGenresUseCase()
        mockMovies.stubbedError = NSError(
            domain: "test",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )
        mockGenres.stubbedResult = []

        let viewModel = MovieListViewModel(getTrendingMovies: mockMovies, getGenres: mockGenres)
        await viewModel.loadInitial()

        #expect(viewModel.error != nil)
        #expect(viewModel.movies.isEmpty)
    }
}
