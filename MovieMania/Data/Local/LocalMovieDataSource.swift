//
//  LocalMovieDataSource.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Combine
import Foundation
import SwiftData

final class LocalMovieDataSource {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func getMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        mainActorPublisher {
            try self.fetchMoviesSync(page: page).map(MovieMapper.toDomain)
        }
    }

    func saveMovies(_ movies: [Movie], page: Int) -> AnyPublisher<Void, Error> {
        mainActorPublisher {
            let entities = movies.map { MovieMapper.toEntity($0, page: page) }
            try self.insertMoviesSync(entities)
        }
    }

    func getMovieDetail(id: Int) -> AnyPublisher<MovieDetail?, Error> {
        mainActorPublisher {
            try self.fetchMovieDetailSync(id: id).map(MovieDetailMapper.toDomain)
        }
    }

    func saveMovieDetail(_ detail: MovieDetail) -> AnyPublisher<Void, Error> {
        mainActorPublisher {
            let entity = MovieDetailMapper.toEntity(detail)
            try self.insertMovieDetailSync(entity)
        }
    }

    @MainActor
    private func fetchMoviesSync(page: Int) throws -> [MovieEntity] {
        let context = modelContainer.mainContext
        let predicate = #Predicate<MovieEntity> { $0.cachedPage == page }
        let descriptor = FetchDescriptor<MovieEntity>(predicate: predicate)
        return try context.fetch(descriptor)
    }

    @MainActor
    private func insertMoviesSync(_ entities: [MovieEntity]) throws {
        let context = modelContainer.mainContext
        for entity in entities {
            context.insert(entity)
        }
        try context.save()
    }

    @MainActor
    private func fetchMovieDetailSync(id: Int) throws -> MovieDetailEntity? {
        let context = modelContainer.mainContext
        let predicate = #Predicate<MovieDetailEntity> { $0.id == id }
        let descriptor = FetchDescriptor<MovieDetailEntity>(predicate: predicate)
        return try context.fetch(descriptor).first
    }

    @MainActor
    private func insertMovieDetailSync(_ entity: MovieDetailEntity) throws {
        let context = modelContainer.mainContext
        context.insert(entity)
        try context.save()
    }
}
