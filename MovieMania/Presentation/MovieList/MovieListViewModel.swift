//
//  MovieListViewModel.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import Combine

@MainActor
final class MovieListViewModel: ObservableObject {
    // MARK: - Published State
    @Published var movies: [Movie] = []
    @Published var filteredMovies: [Movie] = []
    @Published var genres: [Genre] = []
    @Published var selectedGenre: Genre? = nil
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var error: String? = nil

    // MARK: - Pagination
    private var currentPage = 1
    private var totalPages = 1
    private var cancellables = Set<AnyCancellable>()

    var hasMorePages: Bool {
        currentPage < totalPages
    }

    // MARK: - Dependencies
    private let getTrendingMovies: GetTrendingMoviesUseCaseProtocol
    private let getGenres: GetGenresUseCaseProtocol

    // MARK: - Init
    init(
        getTrendingMovies: GetTrendingMoviesUseCaseProtocol,
        getGenres: GetGenresUseCaseProtocol
    ) {
        self.getTrendingMovies = getTrendingMovies
        self.getGenres = getGenres
        setupFilterPipeline()
    }

    // MARK: - Combine Filter Pipeline
    private func setupFilterPipeline() {
        Publishers.CombineLatest3(
            $movies,
            $searchText.debounce(for: .milliseconds(300), scheduler: RunLoop.main),
            $selectedGenre
        )
        .map { movies, searchText, selectedGenre in
            var result = movies
            if let selectedGenre {
                result = result.filter { $0.genreIDs.contains(selectedGenre.id) }
            }
            if !searchText.isEmpty {
                result = result.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText)
                }
            }
            return result
        }
        .receive(on: RunLoop.main)
        .assign(to: &$filteredMovies)
    }

    // MARK: - Actions
    func loadInitial() async {
        guard movies.isEmpty else { return }
        isLoading = true
        error = nil

        async let moviesTask: Void = loadMovies(page: 1)
        async let genresTask: Void = loadGenres()

        _ = await (moviesTask, genresTask)
        isLoading = false
    }

    func loadNextPageIfNeeded(currentItem: Movie) async {
        guard let lastItem = filteredMovies.last,
              lastItem.id == currentItem.id,
              hasMorePages,
              !isLoadingMore else { return }

        isLoadingMore = true
        await loadMovies(page: currentPage + 1)
        isLoadingMore = false
    }

    func toggleGenre(_ genre: Genre) {
        if selectedGenre == genre {
            selectedGenre = nil
        } else {
            selectedGenre = genre
        }
    }

    func retry() async {
        movies = []
        currentPage = 1
        totalPages = 1
        await loadInitial()
    }

    // MARK: - Private
    private func loadMovies(page: Int) async {
        do {
            let response = try await getTrendingMovies.execute(page: page)
            if page == 1 {
                movies = response.results
            } else {
                movies.append(contentsOf: response.results)
            }
            currentPage = response.page
            totalPages = response.totalPages
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func loadGenres() async {
        do {
            genres = try await getGenres.execute()
        } catch {
            // Genres failing is non-critical, don't block the UI
        }
    }
}
