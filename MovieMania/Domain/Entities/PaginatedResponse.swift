//
//  PaginatedResponse.swift
//  MovieMania
//
//  Created by Amr Muhammad on 11/04/2026.
//

import Foundation

struct PaginatedResponse<T: Sendable>: Sendable {
    let results: [T]
    let page: Int
    let totalPages: Int

    init(results: [T], page: Int, totalPages: Int) {
        self.results = results
        self.page = page
        self.totalPages = totalPages
    }

    var hasMorePages: Bool {
        page < totalPages
    }
}
