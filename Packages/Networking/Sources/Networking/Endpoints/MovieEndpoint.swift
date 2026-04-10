//
//  MovieEndpoint.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public enum MovieEndpoint: Endpoint {
    case trending(page: Int)
    case movieDetail(id: Int)
    case genres

    public var path: String {
        switch self {
        case .trending:
            return "/3/discover/movie"
        case .movieDetail(let id):
            return "/3/movie/\(id)"
        case .genres:
            return "/3/genre/movie/list"
        }
    }

    public var queryItems: [URLQueryItem] {
        switch self {
        case .trending(let page):
            return [
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "sort_by", value: "popularity.desc"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .movieDetail, .genres:
            return []
        }
    }
}
