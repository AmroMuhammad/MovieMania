//
//  LocalGenreDataSource.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import SwiftData

final class LocalGenreDataSource {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    @MainActor
    func getGenres() throws -> [GenreEntity] {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<GenreEntity>()
        return try context.fetch(descriptor)
    }

    @MainActor
    func saveGenres(_ entities: [GenreEntity]) throws {
        let context = modelContainer.mainContext
        for entity in entities {
            context.insert(entity)
        }
        try context.save()
    }
}
