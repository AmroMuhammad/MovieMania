//
//  HTTPClient.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Combine
import Foundation

public protocol HTTPClient: Sendable {
    func request<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T

    func requestPublisher<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) -> AnyPublisher<T, APIError>
}
