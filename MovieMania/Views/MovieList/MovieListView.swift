//
//  MovieListView.swift
//  MovieMania
//
//  Created by Amr Muhammad on 13/04/2026.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    let imageBaseURL: String
    let onMovieSelected: (Int) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.lg),
        GridItem(.flexible(), spacing: AppSpacing.lg)
    ]

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.movies.isEmpty {
                LoadingView(message: "Loading movies...")
            } else if let error = viewModel.error, viewModel.movies.isEmpty {
                ErrorStateView(message: error) {
                    viewModel.retry()
                }
            } else {
                movieContent
            }
        }
        .navigationTitle("Watch New Movies")
        .searchable(text: $viewModel.searchText, prompt: "Search TMDB")
        .onAppear {
            viewModel.onAppear()
        }
    }

    @ViewBuilder
    private var movieContent: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                if !viewModel.genres.isEmpty {
                    genreChips
                }
                movieGrid
            }
        }
    }

    @ViewBuilder
    private var genreChips: some View {
        GenreChipsScrollView(
            chips: viewModel.genres.map { genre in
                GenreChipItem(
                    id: genre.id,
                    name: genre.name,
                    isSelected: viewModel.selectedGenre == genre
                )
            },
            onSelect: { genreID in
                if let genre = viewModel.genres.first(where: { $0.id == genreID }) {
                    viewModel.toggleGenre(genre)
                }
            }
        )
    }

    @ViewBuilder
    private var movieGrid: some View {
        if viewModel.filteredMovies.isEmpty && !viewModel.movies.isEmpty {
            if !viewModel.searchText.isEmpty {
                ContentUnavailableView.search(text: viewModel.searchText)
            } else {
                ContentUnavailableView {
                    Label("No Movies Found", systemImage: "film")
                } description: {
                    if let genre = viewModel.selectedGenre {
                        Text("There are no movies matching the \"\(genre.name)\" category.")
                    }
                }
            }
        }

        LazyVGrid(columns: columns, spacing: AppSpacing.lg) {
            ForEach(viewModel.filteredMovies) { movie in
                Button {
                    onMovieSelected(movie.id)
                } label: {
                    MovieRowView(movie: movie, imageBaseURL: imageBaseURL)
                }
                .buttonStyle(.plain)
                .onAppear {
                    viewModel.loadNextPageIfNeeded(currentItem: movie)
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)

        if viewModel.isLoadingMore {
            ProgressView()
                .padding()
        }
    }
}
