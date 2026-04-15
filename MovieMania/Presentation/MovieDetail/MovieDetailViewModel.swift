//
//  MovieDetailViewModel.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Combine
import Foundation

final class MovieDetailViewModel: ObservableObject {
    // MARK: - Published State
    @Published var detail: MovieDetail? = nil
    @Published var isLoading: Bool = false
    @Published var error: String? = nil

    // MARK: - Triggers
    private let loadSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Dependencies
    private let getMovieDetail: GetMovieDetailUseCaseProtocol
    private let movieID: Int

    // MARK: - Init
    init(movieID: Int, getMovieDetail: GetMovieDetailUseCaseProtocol) {
        self.movieID = movieID
        self.getMovieDetail = getMovieDetail
        setupLoadPipeline()
    }

    private func setupLoadPipeline() {
        loadSubject
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
                self?.error = nil
            })
            .flatMap { [getMovieDetail, movieID] in
                getMovieDetail.execute(id: movieID)
                    .map { Result<MovieDetail, Error>.success($0) }
                    .catch { Just(.failure($0)) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let detail):
                    self.detail = detail
                case .failure(let error):
                    self.error = error.localizedDescription
                }
                self.isLoading = false
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    func onAppear() {
        guard detail == nil else { return }
        loadSubject.send()
    }

    func retry() {
        loadSubject.send()
    }

    // MARK: - Formatted Display Properties
    var formattedBudget: String {
        guard let detail, detail.budget > 0 else { return "N/A" }
        return formatCurrency(detail.budget)
    }

    var formattedRevenue: String {
        guard let detail, detail.revenue > 0 else { return "N/A" }
        return formatCurrency(detail.revenue)
    }

    var formattedRuntime: String {
        guard let detail, let runtime = detail.runtime, runtime > 0 else { return "N/A" }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    var releaseYearMonth: String {
        guard let detail, let date = detail.releaseDate, date.count >= 7 else { return "N/A" }
        let components = date.prefix(7).split(separator: "-")
        guard components.count == 2,
              let month = Int(components[1]) else { return String(date.prefix(7)) }

        let monthNames = [
            "", "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        ]
        let monthName = month > 0 && month <= 12 ? monthNames[month] : "\(month)"
        return "\(monthName) \(components[0])"
    }

    var genreList: String {
        guard let detail else { return "" }
        return detail.genres.map(\.name).joined(separator: ", ")
    }

    var languageList: String {
        guard let detail else { return "" }
        return detail.spokenLanguages.joined(separator: ", ")
    }

    // MARK: - Private
    private func formatCurrency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}
