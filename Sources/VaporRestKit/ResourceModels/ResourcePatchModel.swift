//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 17.05.2020.
//

import Vapor
import Fluent


public protocol ResourcePatchModel: Content, Validatable {
    associatedtype Model: Fields

    func patch(_: Model) throws -> Model

    func patch(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}


public extension ResourcePatchModel {
    func patch(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
        return req.eventLoop.tryFuture { try patch(model) }
    }
}
