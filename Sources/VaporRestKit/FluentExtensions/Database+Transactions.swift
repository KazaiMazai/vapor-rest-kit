//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.05.2020.
//

import Fluent
import Vapor

extension Database {
    func tryTransaction<T>(_ closure: @escaping (Database) throws -> EventLoopFuture<T>) -> EventLoopFuture<T> {
        transaction { (db) -> EventLoopFuture<T> in
            db.context.eventLoop
                .tryFuture { try closure(db) }
                .flatMap { $0 }
        }

    }

}
