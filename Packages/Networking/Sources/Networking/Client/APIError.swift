//
//  APIError.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public enum APIError: Error, Sendable, LocalizedError {
    case invalidURL
    case networkError(Error)
    case httpError(statusCode: Int, data: Data)
    case decodingError(Error)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .httpError(let statusCode, _):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
