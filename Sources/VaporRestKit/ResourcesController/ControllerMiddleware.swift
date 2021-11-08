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

    fileprivate let handler: Handler

    public init(handler: @escaping Handler) {
        self.handler = handler
    }

    func handle(_ model: Model,
                relatedModel: RelatedModel,
                req: Request,
                database: Database) -> EventLoopFuture<(Model, RelatedModel)> {

        handler(model, relatedModel, req, database)
    }
}

public extension ControllerMiddleware {
    static var empty: ControllerMiddleware<Model, RelatedModel> {
        ControllerMiddleware { model, relatedModel, req, _ in
            req.eventLoop.makeSucceededFuture((model, relatedModel))
        }
    }
}
