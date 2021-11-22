//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.09.2021.
//


import Vapor
import Fluent

@available(*, deprecated, renamed: "Deleter")
public typealias DeleteHandler = Deleter

public struct Deleter<Model: Fluent.Model> {
    public typealias Handler = (Model, Bool, Request, Database) -> EventLoopFuture<Model>

    private let handler: Handler
    private let useForcedDelete: Bool

    public init(useForcedDelete: Bool = false,
                handler: @escaping Handler = Self.defaultDeleteHandler) {
        self.handler = handler
        self.useForcedDelete = useForcedDelete
    }

    public static func defaultDeleteHandler(_ model: Model,
                                            forceDelete: Bool,
                                            req: Request,
                                            db: Database) -> EventLoopFuture<Model> {

        model.delete(force: forceDelete, on: db).transform(to: model)
    }

    func performDelete(_ model: Model,
                       req: Request,
                       database: Database) -> EventLoopFuture<Model> {

        handler(model, useForcedDelete, req, database)
    }
}

public extension Deleter {
    static func defaultDeleter(useForcedDelete: Bool = false) -> Deleter<Model> {
        Deleter(useForcedDelete: useForcedDelete)  { model, forceDelete, _, db in
            model.delete(force: forceDelete, on: db).transform(to: model)
        }
    }
}
