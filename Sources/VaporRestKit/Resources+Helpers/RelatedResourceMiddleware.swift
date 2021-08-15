//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 17.05.2020.
//

import Vapor
import Fluent

public struct RelatedResourceMiddleware<Model: Fluent.Model, RelatedModel: Fluent.Model> {
    public typealias Handler = (Model, RelatedModel, Request, Database) -> EventLoopFuture<(Model, RelatedModel)>

    fileprivate let handler: Handler

    public init(handler: @escaping Handler) {
        self.handler = handler
    }

    public static var empty: RelatedResourceMiddleware<Model, RelatedModel> {
        RelatedResourceMiddleware { model, relatedModel, req, _ in
            req.eventLoop.makeSucceededFuture((model, relatedModel))
        }
    }

    func handle(_ model: Model,
                relatedModel: RelatedModel,
                req: Request,
                database: Database) -> EventLoopFuture<(Model, RelatedModel)> {
        return handler(model, relatedModel, req, database)
    }
}
