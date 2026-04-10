//
//  GenreDTO.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public struct GenreDTO: Decodable, Sendable {
    public let id: Int
    public let name: String
}
