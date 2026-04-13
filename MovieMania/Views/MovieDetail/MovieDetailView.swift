//
//  MovieDetailView.swift
//  MovieMania
//
//  Created by Amr Muhammad on 13/04/2026.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    let imageBaseURL: String

    private var posterURL: URL? {
        guard let posterPath = viewModel.detail?.posterPath else { return nil }
        return URL(string: "\(imageBaseURL)/w780\(posterPath)")
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(message: "Loading details...")
            } else if let error = viewModel.error, viewModel.detail == nil {
                ErrorStateView(message: error) {
                    viewModel.retry()
                }
            } else if let detail = viewModel.detail {
                detailContent(detail)
            }
        }
        .navigationTitle(viewModel.detail?.title ?? "Movie Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.onAppear()
        }
    }

    @ViewBuilder
    private func detailContent(_ detail: MovieDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                posterSection
                titleSection(detail)
                genreSection
                overviewSection(detail)
                detailsGrid
            }
        }
    }

    @ViewBuilder
    private var posterSection: some View {
        CachedAsyncImage(url: posterURL)
            .aspectRatio(2/3, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .clipped()
    }

    @ViewBuilder
    private func titleSection(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("\(detail.title) (\(viewModel.releaseYearMonth))")
                .font(AppFonts.title)
                .foregroundStyle(AppColors.label)
        }
        .padding(.horizontal, AppSpacing.lg)
    }

    @ViewBuilder
    private var genreSection: some View {
        if !viewModel.genreList.isEmpty {
            Text(viewModel.genreList)
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.secondaryLabel)
                .padding(.horizontal, AppSpacing.lg)
        }
    }

    @ViewBuilder
    private func overviewSection(_ detail: MovieDetail) -> some View {
        if !detail.overview.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Overview")
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.label)

                Text(detail.overview)
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.secondaryLabel)
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }

    @ViewBuilder
    private var detailsGrid: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            if let homepage = viewModel.detail?.homepage, !homepage.isEmpty {
                detailRow(title: "Homepage", value: homepage, isLink: true)
            }

            if !viewModel.languageList.isEmpty {
                detailRow(title: "Languages", value: viewModel.languageList)
            }

            HStack(spacing: AppSpacing.xxl) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    detailRow(title: "Status", value: viewModel.detail?.status ?? "N/A")
                    detailRow(title: "Budget", value: viewModel.formattedBudget)
                }

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    detailRow(title: "Runtime", value: viewModel.formattedRuntime)
                    detailRow(title: "Revenue", value: viewModel.formattedRevenue)
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xxl)
    }

    @ViewBuilder
    private func detailRow(title: String, value: String, isLink: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
            Text(title)
                .font(AppFonts.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.label)

            if isLink, let url = URL(string: value) {
                Link(value, destination: url)
                    .font(AppFonts.caption2)
                    .tint(AppColors.primary)
            } else {
                Text(value)
                    .font(AppFonts.caption2)
                    .foregroundStyle(AppColors.secondaryLabel)
            }
        }
    }
}
