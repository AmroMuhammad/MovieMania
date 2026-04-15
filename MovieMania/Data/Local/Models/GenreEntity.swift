//
//  GenreEntity.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Foundation
import SwiftData

@Model
final class GenreEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var cachedAt: Date

    init(id: Int, name: String, cachedAt: Date = .now) {
        self.id = id
        self.name = name
        self.cachedAt = cachedAt
    }
}
