//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 17.05.2020.
//

import Vapor
import Fluent

public protocol ResourcePatchModel: ResourceMutationModel {
    func patch(_: Model) throws -> Model

    func patch(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}

public extension ResourcePatchModel {
    func patch(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
        return req.eventLoop.tryFuture { try patch(model) }
    }
}

public extension ResourcePatchModel {
    func mutate(_ model: Model) throws -> Model {
        try patch(model)
    }

    func mutate(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
        patch(model, req: req, database: database)
    }
}
