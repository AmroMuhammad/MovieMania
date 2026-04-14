//
//  MovieDetailViewModelTests.swift
//  MovieMania
//
//  Created by Amr Muhammad on 14/04/2026.
//

import Testing
import Foundation
@testable import MovieMania

@MainActor
struct MovieDetailViewModelTests {
    private func makeDetail() -> MovieDetail {
        MovieDetail(
            id: 1,
            title: "Test Movie",
            posterPath: "/poster.jpg",
            releaseDate: "2024-05-15",
            genres: [Genre(id: 28, name: "Action"), Genre(id: 12, name: "Adventure")],
            overview: "A great movie",
            homepage: "https://example.com",
            budget: 50_000_000,
            revenue: 253_000_000,
            spokenLanguages: ["English", "Spanish"],
            status: "Released",
            runtime: 102
        )
    }

    @Test func loadDetailSetsDetail() async {
        let mock = MockGetMovieDetailUseCase()
        mock.stubbedResult = makeDetail()

        let viewModel = MovieDetailViewModel(movieID: 1, getMovieDetail: mock)
        await viewModel.loadDetail()

        #expect(viewModel.detail != nil)
        #expect(viewModel.detail?.title == "Test Movie")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
    }

    @Test func formattedRuntime() async {
        let mock = MockGetMovieDetailUseCase()
        mock.stubbedResult = makeDetail()

        let viewModel = MovieDetailViewModel(movieID: 1, getMovieDetail: mock)
        await viewModel.loadDetail()

        #expect(viewModel.formattedRuntime == "1h 42m")
    }

    @Test func genreList() async {
        let mock = MockGetMovieDetailUseCase()
        mock.stubbedResult = makeDetail()

        let viewModel = MovieDetailViewModel(movieID: 1, getMovieDetail: mock)
        await viewModel.loadDetail()

        #expect(viewModel.genreList == "Action, Adventure")
    }

    @Test func languageList() async {
        let mock = MockGetMovieDetailUseCase()
        mock.stubbedResult = makeDetail()

        let viewModel = MovieDetailViewModel(movieID: 1, getMovieDetail: mock)
        await viewModel.loadDetail()

        #expect(viewModel.languageList == "English, Spanish")
    }

    @Test func releaseYearMonth() async {
        let mock = MockGetMovieDetailUseCase()
        mock.stubbedResult = makeDetail()

        let viewModel = MovieDetailViewModel(movieID: 1, getMovieDetail: mock)
        await viewModel.loadDetail()

        #expect(viewModel.releaseYearMonth == "May 2024")
    }

    @Test func errorStateOnLoadFailure() async {
        let mock = MockGetMovieDetailUseCase()
        mock.stubbedError = NSError(
            domain: "test",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )

        let viewModel = MovieDetailViewModel(movieID: 1, getMovieDetail: mock)
        await viewModel.loadDetail()

        #expect(viewModel.error != nil)
        #expect(viewModel.detail == nil)
    }
}
