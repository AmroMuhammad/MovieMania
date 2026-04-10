//
//  APIConfiguration.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public struct APIConfiguration: Sendable {
    public let baseURL: String
    public let apiKey: String
    public let imageBaseURL: String

    public init(
        baseURL: String = "https://api.themoviedb.org",
        apiKey: String,
        imageBaseURL: String = "https://image.tmdb.org/t/p"
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.imageBaseURL = imageBaseURL
    }

    public func posterURL(path: String, size: ImageSize = .w500) -> URL? {
        URL(string: "\(imageBaseURL)/\(size.rawValue)\(path)")
    }
}

public enum ImageSize: String, Sendable {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original
}
