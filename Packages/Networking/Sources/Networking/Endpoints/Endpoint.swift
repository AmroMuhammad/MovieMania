//
//  Endpoint.swift
//  MovieMania
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
}

public protocol Endpoint: Sendable {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
}

extension Endpoint {
    public var method: HTTPMethod { .get }

    public var headers: [String: String] {
        ["Content-Type": "application/json"]
    }

    public func urlRequest(with configuration: APIConfiguration) -> URLRequest? {
        guard var components = URLComponents(string: configuration.baseURL + path) else {
            return nil
        }

        var allQueryItems = queryItems
        allQueryItems.append(URLQueryItem(name: "api_key", value: configuration.apiKey))

        if !allQueryItems.isEmpty {
            components.queryItems = allQueryItems
        }

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}
