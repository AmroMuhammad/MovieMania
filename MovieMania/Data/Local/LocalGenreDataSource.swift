//
//  LocalGenreDataSource.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Combine
import Foundation
import SwiftData

final class LocalGenreDataSource {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func getGenres() -> AnyPublisher<[Genre], Error> {
        mainActorPublisher {
            try self.fetchGenresSync().map(GenreMapper.toDomain)
        }
    }

    func saveGenres(_ genres: [Genre]) -> AnyPublisher<Void, Error> {
        mainActorPublisher {
            let entities = genres.map(GenreMapper.toEntity)
            try self.insertGenresSync(entities)
        }
    }

    @MainActor
    private func fetchGenresSync() throws -> [GenreEntity] {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<GenreEntity>()
        return try context.fetch(descriptor)
    }

    @MainActor
    private func insertGenresSync(_ entities: [GenreEntity]) throws {
        let context = modelContainer.mainContext
        for entity in entities {
            context.insert(entity)
        }
        try context.save()
    }
}
