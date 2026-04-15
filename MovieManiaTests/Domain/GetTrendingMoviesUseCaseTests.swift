//
//  GetTrendingMoviesUseCaseTests.swift
//  MovieMania
//
//  Created by Amr Muhammad on 14/04/2026.
//

import Testing
@testable import MovieMania

@MainActor
struct GetTrendingMoviesUseCaseTests {
    @Test func executeCallsRepository() throws {
        let mockRepo = MockMovieRepository()
        let expected = [
            Movie(id: 1, title: "Test Movie", posterPath: nil, releaseDate: "2024-05-15", genreIDs: [28])
        ]
        mockRepo.stubbedTrendingResult = PaginatedResponse(results: expected, page: 1, totalPages: 5)

        let useCase = GetTrendingMoviesUseCase(repository: mockRepo)
        let result = try useCase.execute(page: 1).collectFirst()

        #expect(result.results.count == 1)
        #expect(result.results.first?.title == "Test Movie")
        #expect(result.page == 1)
        #expect(result.totalPages == 5)
        #expect(mockRepo.getTrendingCallCount == 1)
    }

    @Test func executePropagatesPagination() throws {
        let mockRepo = MockMovieRepository()
        mockRepo.stubbedTrendingResult = PaginatedResponse(results: [], page: 3, totalPages: 10)

        let useCase = GetTrendingMoviesUseCase(repository: mockRepo)
        let result = try useCase.execute(page: 3).collectFirst()

        #expect(result.page == 3)
        #expect(result.totalPages == 10)
        #expect(result.hasMorePages == true)
    }
}
