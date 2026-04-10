//
//  HTTPClient.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public protocol HTTPClient: Sendable {
    func request<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T
}
