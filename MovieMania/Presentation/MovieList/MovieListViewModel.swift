//
//  MovieListViewModel.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Combine
import Foundation

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

    // MARK: - Triggers
    private let loadPageSubject = PassthroughSubject<Int, Never>()
    private let loadGenresSubject = PassthroughSubject<Void, Never>()

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
        setupLoadPipelines()
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

    // MARK: - Load Pipelines
    private func setupLoadPipelines() {
        loadPageSubject
            .handleEvents(receiveOutput: { [weak self] page in
                guard let self else { return }
                if page == 1 {
                    self.isLoading = true
                } else {
                    self.isLoadingMore = true
                }
                self.error = nil
            })
            .flatMap { [getTrendingMovies] page in
                getTrendingMovies.execute(page: page)
                    .map { Result<(PaginatedResponse<Movie>, Int), Error>.success(($0, page)) }
                    .catch { Just(.failure($0)) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let (response, page)):
                    if page == 1 {
                        self.movies = response.results
                    } else {
                        self.movies.append(contentsOf: response.results)
                    }
                    self.currentPage = response.page
                    self.totalPages = response.totalPages
                    self.error = nil
                case .failure(let error):
                    self.error = error.localizedDescription
                }
                self.isLoading = false
                self.isLoadingMore = false
            }
            .store(in: &cancellables)

        loadGenresSubject
            .flatMap { [getGenres] in
                getGenres.execute()
                    .map { Result<[Genre], Error>.success($0) }
                    .catch { Just(.failure($0)) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if case .success(let genres) = result {
                    self?.genres = genres
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    func onAppear() {
        guard movies.isEmpty else { return }
        loadPageSubject.send(1)
        loadGenresSubject.send()
    }

    func loadNextPageIfNeeded(currentItem: Movie) {
        guard let lastItem = filteredMovies.last,
              lastItem.id == currentItem.id,
              hasMorePages,
              !isLoadingMore else { return }

        loadPageSubject.send(currentPage + 1)
    }

    func toggleGenre(_ genre: Genre) {
        if selectedGenre == genre {
            selectedGenre = nil
        } else {
            selectedGenre = genre
        }
    }

    func retry() {
        movies = []
        currentPage = 1
        totalPages = 1
        loadPageSubject.send(1)
        loadGenresSubject.send()
    }

    func retryPagination() {
        guard !movies.isEmpty, hasMorePages else { return }
        loadPageSubject.send(currentPage + 1)
    }

    @MainActor
    func refresh() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            var cancellable: AnyCancellable?
            cancellable = $isLoading
                .dropFirst()
                .filter { !$0 }
                .first()
                .sink { _ in
                    continuation.resume()
                    cancellable?.cancel()
                }

            currentPage = 1
            totalPages = 1
            loadPageSubject.send(1)
            loadGenresSubject.send()
        }
    }
}
