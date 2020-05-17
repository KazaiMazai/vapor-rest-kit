//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 17.05.2020.
//

import Vapor
import Fluent


public struct ResourceControllerMiddleware<Model: Fluent.Model> {
    public typealias Handler = (Model, Request, Database) -> EventLoopFuture<Model>

    fileprivate let willSaveHandler: Handler

    public init(willSave: @escaping Handler = Self.empty) {
        self.willSaveHandler = willSave
    }

    public func willSave(_ model: Model,
                         req: Request,
                         database: Database) -> EventLoopFuture<Model> {

        return willSaveHandler(model, req, database)
    }

    public static var defaultMiddleware: ResourceControllerMiddleware<Model> {
        return ResourceControllerMiddleware(willSave: empty)
    }

    public static var empty: Handler {
        return { model, req, _ in req.eventLoop.makeSucceededFuture(model) }
    }
}
