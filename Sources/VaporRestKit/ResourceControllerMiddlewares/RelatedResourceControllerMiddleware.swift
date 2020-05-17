//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 17.05.2020.
//

import Vapor
import Fluent


public struct RelatedResourceControllerMiddleware<Model: Fluent.Model, RelatedModel: Fluent.Model> {
    public typealias Handler = (Model, RelatedModel, Request, Database) -> EventLoopFuture<(Model, RelatedModel)>

    fileprivate let willSaveHandler: Handler

    public init(willSave: @escaping Handler = Self.empty) {
        self.willSaveHandler = willSave
    }

    public func willSave(_ model: Model,
                         relatedModel: RelatedModel,
                         req: Request,
                         database: Database) -> EventLoopFuture<(Model, RelatedModel)> {
        return willSaveHandler(model, relatedModel, req, database)
    }


    public static var defaultMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> {
        return RelatedResourceControllerMiddleware(willSave: empty)
    }

    public static var empty: Handler {
        return { model, relatedModel, req, _ in req.eventLoop.makeSucceededFuture((model, relatedModel)) }
    }
}
