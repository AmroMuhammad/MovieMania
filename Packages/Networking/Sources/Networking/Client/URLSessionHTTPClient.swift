//
//  URLSessionHTTPClient.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let configuration: APIConfiguration
    private let decoder: JSONDecoder

    public init(
        session: URLSession = .shared,
        configuration: APIConfiguration
    ) {
        self.session = session
        self.configuration = configuration

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    public func request<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {
        guard let request = endpoint.urlRequest(with: configuration) else {
            throw APIError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
