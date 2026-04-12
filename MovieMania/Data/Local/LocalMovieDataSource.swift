//
//  LocalMovieDataSource.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import SwiftData

final class LocalMovieDataSource {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    @MainActor
    func getMovies(page: Int) throws -> [MovieEntity] {
        let context = modelContainer.mainContext
        let predicate = #Predicate<MovieEntity> { $0.cachedPage == page }
        let descriptor = FetchDescriptor<MovieEntity>(predicate: predicate)
        return try context.fetch(descriptor)
    }

    @MainActor
    func saveMovies(_ entities: [MovieEntity]) throws {
        let context = modelContainer.mainContext
        for entity in entities {
            context.insert(entity)
        }
        try context.save()
    }

    @MainActor
    func getMovieDetail(id: Int) throws -> MovieDetailEntity? {
        let context = modelContainer.mainContext
        let predicate = #Predicate<MovieDetailEntity> { $0.id == id }
        let descriptor = FetchDescriptor<MovieDetailEntity>(predicate: predicate)
        return try context.fetch(descriptor).first
    }

    @MainActor
    func saveMovieDetail(_ entity: MovieDetailEntity) throws {
        let context = modelContainer.mainContext
        context.insert(entity)
        try context.save()
    }
}
