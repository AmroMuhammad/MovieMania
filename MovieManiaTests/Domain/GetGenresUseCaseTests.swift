//
//  GetGenresUseCaseTests.swift
//  MovieMania
//
//  Created by Amr Muhammad on 14/04/2026.
//

import Testing
@testable import MovieMania

@MainActor
struct GetGenresUseCaseTests {
    @Test func executeReturnsGenres() throws {
        let mockRepo = MockGenreRepository()
        mockRepo.stubbedGenres = [
            Genre(id: 28, name: "Action"),
            Genre(id: 12, name: "Adventure"),
            Genre(id: 35, name: "Comedy")
        ]

        let useCase = GetGenresUseCase(repository: mockRepo)
        let result = try useCase.execute().collectFirst()

        #expect(result.count == 3)
        #expect(result[0].name == "Action")
        #expect(result[2].name == "Comedy")
        #expect(mockRepo.getGenresCallCount == 1)
    }
}
