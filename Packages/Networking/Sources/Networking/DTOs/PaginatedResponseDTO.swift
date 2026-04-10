//
//  PaginatedResponseDTO.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public struct PaginatedResponseDTO<T: Decodable & Sendable>: Decodable, Sendable {
    public let page: Int
    public let results: [T]
    public let totalPages: Int
    public let totalResults: Int
}
