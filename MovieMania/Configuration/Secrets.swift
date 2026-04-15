//
//  Secrets.swift
//  MovieMania
//
//  Created by Amr Muhammad on 13/04/2026.
//

import Foundation

enum Secrets {
    static let tmdbAPIKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TMDBAPIKey") as? String,
              !key.isEmpty else {
            fatalError("TMDBAPIKey missing from Info.plist — set INFOPLIST_KEY_TMDBAPIKey in build settings.")
        }
        return key
    }()
}
