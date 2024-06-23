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

    func update(_ model: Model, req: Request, database: Database) async throws -> Model
    
    func update(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}

public extension ResourceUpdateModel {
    func update(_ model: Model, req: Request, database: Database) async throws -> Model {
        try await database.eventLoop.tryFuture { try update(model) }.get()
    }
    
    func update(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
        database.eventLoop.withTask {
            try await update(model, req: req, database: database)
        }
    }
}

public extension ResourceUpdateModel {
    func mutate(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
        update(model, req: req, database: database)
    }
}
