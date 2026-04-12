//
//  MovieDetailViewModel.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {
    // MARK: - Published State
    @Published var detail: MovieDetail? = nil
    @Published var isLoading: Bool = false
    @Published var error: String? = nil

    // MARK: - Dependencies
    private let getMovieDetail: GetMovieDetailUseCaseProtocol
    private let movieID: Int

    // MARK: - Init
    init(movieID: Int, getMovieDetail: GetMovieDetailUseCaseProtocol) {
        self.movieID = movieID
        self.getMovieDetail = getMovieDetail
    }

    // MARK: - Actions
    func loadDetail() async {
        isLoading = true
        error = nil

        do {
            detail = try await getMovieDetail.execute(id: movieID)
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
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
