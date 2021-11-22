//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 17.05.2020.
//

import Vapor
import Fluent

public protocol ResourceUpdateModel: ResourceMutationModel {
    func update(_: Model) throws -> Model

    func update(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}

public extension ResourceUpdateModel {
    func update(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
        return req.eventLoop.tryFuture { try update(model) }
    }
}

public extension ResourceUpdateModel {
    func mutate(_ model: Model) throws -> Model {
        try update(model)
    }

    func mutate(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
        update(model, req: req, database: database)
    }
}
