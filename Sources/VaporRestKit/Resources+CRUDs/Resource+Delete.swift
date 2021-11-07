//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

public extension ResourceController {
    func delete<Model>(
        req: Request,
        using deleter: Deleter<Model> = .defaultDeleter(),
        queryModifier: QueryModifier<Model> = .empty) throws -> EventLoopFuture<Output>
    where
        Output.Model == Model {

        req.db.tryTransaction { db in
            try Model
                .findByIdKey(req, database: db, queryModifier: queryModifier)
                .flatMap { model in
                    deleter
                        .performDelete(model, req: req, database: db)
                        .transform(to: model) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

public extension RelatedResourceController {

    func delete<Model, RelatedModel>(
        resolver: ChildResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        Model == Output.Model {

        req.db.tryTransaction { db in

            try resolver
                .find(req, db, relationKeyPath, queryModifier)
                .flatMap { (model, related) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMap { (model, related) in
                    deleter
                        .performDelete(model, req: req, database: db)
                        .transform(to: model) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    func delete<Model, RelatedModel>(
        resolver: ParentResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Model == Output.Model {

        req.db.tryTransaction { db in

            try resolver
                .find(req, db, relationKeyPath, queryModifier)
                .flatMap { (model, related) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (model, related) in
                    try model.detached(from: related, with: relationKeyPath)
                    return related.save(on: db).transform(to: model) }
                .flatMap { $0 }
                .flatMap { model in
                    deleter
                        .performDelete(model, req: req, database: db)
                        .transform(to: model) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    func delete<Model, RelatedModel, Through>(
        resolver: SiblingsResolver<Model, RelatedModel, Through> = .byIdKeys,
        req: Request,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where

        Model == Output.Model {

        req.db.tryTransaction { db in

            try resolver
                .find(req, db, relationKeyPath, queryModifier)
                .flatMap { (model, related) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMap { (model, related) in model.detached(from: related, with: relationKeyPath, on: db) }
                .flatMap { model in
                    deleter
                        .performDelete(model, req: req, database: db)
                        .transform(to: model) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}
