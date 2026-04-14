//
//  PublisherTestHelpers.swift
//  MovieMania
//
//  Created by Amr Muhammad on 14/04/2026.
//

import Combine
import Foundation

extension Publisher where Failure == Error {
    /// Synchronously subscribes to the publisher and returns the first emitted value.
    /// Throws either the publisher's failure or a "no value" error if it completes empty.
    /// Suitable for synchronous publishers (e.g. `Just`, `Fail`) used in mocks.
    func collectFirst() throws -> Output {
        var captured: Output?
        var failure: Error?
        let cancellable = self.sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    failure = error
                }
            },
            receiveValue: { value in
                if captured == nil { captured = value }
            }
        )
        _ = cancellable
        if let failure { throw failure }
        guard let captured else {
            throw NSError(
                domain: "PublisherTestHelpers",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Publisher completed without emitting a value"]
            )
        }
        return captured
    }
}

/// Pumps the main run loop briefly so that `DispatchQueue.main`-scheduled
/// Combine deliveries (e.g. `.receive(on: DispatchQueue.main)` in ViewModels)
/// land before assertions run. Keeps tests synchronous — no async/await.
@MainActor
func drainMainQueue(_ duration: TimeInterval = 0.05) {
    RunLoop.main.run(until: Date(timeIntervalSinceNow: duration))
}
