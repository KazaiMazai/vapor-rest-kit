//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23/06/2024.
//

import Vapor

extension EventLoop {
    func withTask<T>(task: @escaping () async throws -> T) -> EventLoopFuture<T> {
        let promise = makePromise(of: T.self)
        promise.completeWithTask { try await task() }
        return promise.futureResult
    }
}
