//
//  MovieManiaApp.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import SwiftUI
import SwiftData

@main
struct MovieManiaApp: App {
    @State private var container = DependencyContainer()
    @State private var navigationPath = NavigationPath()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                MovieListView(
                    viewModel: container.makeMovieListViewModel(),
                    imageBaseURL: container.imageBaseURL
                ) { movieID in
                    navigationPath.append(Route.movieDetail(id: movieID))
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .movieDetail(let id):
                        MovieDetailView(
                            viewModel: container.makeMovieDetailViewModel(movieID: id),
                            imageBaseURL: container.imageBaseURL
                        )
                    }
                }
            }
        }
        .modelContainer(container.modelContainer)
    }
}
