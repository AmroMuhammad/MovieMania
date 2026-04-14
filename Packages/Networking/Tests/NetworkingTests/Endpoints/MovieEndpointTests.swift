//
//  MovieEndpointTests.swift
//  MovieMania
//
//  Created by Amr Muhammad on 14/04/2026.
//

import Testing
@testable import Networking

struct MovieEndpointTests {
    let config = APIConfiguration(apiKey: "test_api_key")

    @Test func trendingEndpointPath() {
        let endpoint = MovieEndpoint.trending(page: 1)
        #expect(endpoint.path == "/3/discover/movie")
    }

    @Test func trendingEndpointQueryItems() {
        let endpoint = MovieEndpoint.trending(page: 2)
        let queryItems = endpoint.queryItems

        #expect(queryItems.contains { $0.name == "include_adult" && $0.value == "false" })
        #expect(queryItems.contains { $0.name == "sort_by" && $0.value == "popularity.desc" })
        #expect(queryItems.contains { $0.name == "page" && $0.value == "2" })
    }

    @Test func trendingEndpointURLRequest() {
        let endpoint = MovieEndpoint.trending(page: 1)
        let request = endpoint.urlRequest(with: config)

        #expect(request != nil)
        let url = request!.url!.absoluteString
        #expect(url.contains("api.themoviedb.org/3/discover/movie"))
        #expect(url.contains("api_key=test_api_key"))
        #expect(url.contains("page=1"))
    }

    @Test func movieDetailEndpointPath() {
        let endpoint = MovieEndpoint.movieDetail(id: 550)
        #expect(endpoint.path == "/3/movie/550")
    }

    @Test func movieDetailEndpointURLRequest() {
        let endpoint = MovieEndpoint.movieDetail(id: 550)
        let request = endpoint.urlRequest(with: config)

        #expect(request != nil)
        let url = request!.url!.absoluteString
        #expect(url.contains("/3/movie/550"))
        #expect(url.contains("api_key=test_api_key"))
    }

    @Test func genresEndpointPath() {
        let endpoint = MovieEndpoint.genres
        #expect(endpoint.path == "/3/genre/movie/list")
    }

    @Test func genresEndpointHasNoExtraQueryItems() {
        let endpoint = MovieEndpoint.genres
        #expect(endpoint.queryItems.isEmpty)
    }

    @Test func allEndpointsUseGetMethod() {
        #expect(MovieEndpoint.trending(page: 1).method == .get)
        #expect(MovieEndpoint.movieDetail(id: 1).method == .get)
        #expect(MovieEndpoint.genres.method == .get)
    }
}
