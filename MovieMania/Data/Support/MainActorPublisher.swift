//
//  MainActorPublisher.swift
//  MovieMania
//
//  Created by Amr Muhammad on 12/04/2026.
//

import Combine
import Foundation

func mainActorPublisher<Output>(
    _ body: @escaping @MainActor () throws -> Output
) -> AnyPublisher<Output, Error> {
    Deferred {
        Future { promise in
            Task { @MainActor in
                do { promise(.success(try body())) }
                catch { promise(.failure(error)) }
            }
        }
    }
    .eraseToAnyPublisher()
}
