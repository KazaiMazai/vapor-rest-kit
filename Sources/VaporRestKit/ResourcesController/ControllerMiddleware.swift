//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 17.05.2020.
//

import Vapor
import Fluent

@available(*, deprecated, renamed: "ControllerMiddleware")
public typealias RelatedResourceControllerMiddleware = ControllerMiddleware

public struct ControllerMiddleware<Model: Fluent.Model, RelatedModel: Fluent.Model> {
    public typealias Handler = (Model, RelatedModel, Request, Database) -> EventLoopFuture<(Model, RelatedModel)>
    public typealias AsyncHandler = (Model, RelatedModel, Request, Database) async throws -> (Model, RelatedModel)
    
    private let handler: Handler

    public init(handler: @escaping Handler) {
        self.handler = handler
    }
    
    public init(handler: @escaping AsyncHandler) {
        self.handler = { model, relatedModel, req, db in
            db.eventLoop.withTask { try await handler(model, relatedModel, req, db) }
        }
    }
}

public extension ControllerMiddleware {
    static var empty: ControllerMiddleware<Model, RelatedModel> {
        ControllerMiddleware { model, relatedModel, req, _ in
            req.eventLoop.makeSucceededFuture((model, relatedModel))
        }
    }
}

extension ControllerMiddleware {
    func handle(_ model: Model,
                relatedModel: RelatedModel,
                req: Request,
                database: Database) -> EventLoopFuture<(Model, RelatedModel)> {

        handler(model, relatedModel, req, database)
    }
}

extension ControllerMiddleware where Model == RelatedModel {
    public typealias SingleModelHandler = (Model, Request, Database) -> EventLoopFuture<Model>
    public typealias AsyncSingleModelHandler = (Model, Request, Database) async throws -> Model
    
    public init(handler: @escaping SingleModelHandler) {
        self.handler = { model, _, req, db in
            handler(model, req, db).map { ($0, $0) }
        }
    }
    
    public init(handler: @escaping AsyncSingleModelHandler) {
        self.handler = { model, _, req, db in
            db.eventLoop.withTask {
                let result = try await handler(model, req, db)
                return (result, result)
            }
        }
    }
    
    func handle(_ model: Model,
                req: Request,
                database: Database) -> EventLoopFuture<Model> {

        handler(model, model, req, database).map { $0.0 }
    }
}
 
