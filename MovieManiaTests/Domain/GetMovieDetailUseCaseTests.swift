//
//  GetMovieDetailUseCaseTests.swift
//  MovieMania
//
//  Created by Amr Muhammad on 14/04/2026.
//

import Testing
@testable import MovieMania

struct GetMovieDetailUseCaseTests {
    @Test func executeReturnsDetail() async throws {
        let mockRepo = MockMovieRepository()
        let expected = MovieDetail(
            id: 1,
            title: "Test Movie",
            posterPath: "/poster.jpg",
            releaseDate: "2024-05-15",
            genres: [Genre(id: 28, name: "Action")],
            overview: "A test movie overview",
            homepage: "https://example.com",
            budget: 1_000_000,
            revenue: 5_000_000,
            spokenLanguages: ["English"],
            status: "Released",
            runtime: 120
        )
        mockRepo.stubbedDetailResult = expected

        let useCase = GetMovieDetailUseCase(repository: mockRepo)
        let result = try await useCase.execute(id: 1)

        #expect(result.id == 1)
        #expect(result.title == "Test Movie")
        #expect(result.genres.count == 1)
        #expect(result.budget == 1_000_000)
        #expect(mockRepo.getDetailCallCount == 1)
    }
}
