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
        resolver: Resolver<Model> = .byIdKeys,
        req: Request,
        db: (any Database)? = nil,
        using deleter: Deleter<Model> = .defaultDeleter(),
        queryModifier: QueryModifier<Model> = .empty) throws -> EventLoopFuture<Output>
    where
        Output.Model == Model {

        (db ?? req.db).tryTransaction { db in
            try resolver
                .find(req, req.db, queryModifier)
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
        db: (any Database)? = nil,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        Model == Output.Model {

        (db ?? req.db).tryTransaction { db in

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
        db: (any Database)? = nil,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Model == Output.Model {

        (db ?? req.db).tryTransaction { db in

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
        db: (any Database)? = nil,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where

        Model == Output.Model {

        (db ?? req.db).tryTransaction { db in

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

//MARK: - Concurrency

public extension ResourceController {
    func delete<Model>(
        req: Request,
        db: (any Database)? = nil,
        using deleter: Deleter<Model> = .defaultDeleter(),
        queryModifier: QueryModifier<Model> = .empty) async throws -> Output
    where
        Output.Model == Model {

        try await delete(
            req: req,
            db: db,
            using: deleter,
            queryModifier: queryModifier
        ).get()
    }
}

public extension RelatedResourceController {

    func delete<Model, RelatedModel>(
        resolver: ChildResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        db: (any Database)? = nil,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) async throws -> Output
    where
        Model == Output.Model {

            try await delete(
                resolver: resolver,
                req: req,
                db: db,
                using: deleter,
                willDetach: middleware,
                queryModifier: queryModifier,
                relationKeyPath: relationKeyPath
            ).get()
    }

    func delete<Model, RelatedModel>(
        resolver: ParentResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        db: (any Database)? = nil,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) async throws -> Output
    where
        Model == Output.Model {

            try await delete(
                resolver: resolver,
                req: req,
                db: db,
                using: deleter,
                willDetach: middleware,
                queryModifier: queryModifier,
                relationKeyPath: relationKeyPath
            ).get()
    }

    func delete<Model, RelatedModel, Through>(
        resolver: SiblingsResolver<Model, RelatedModel, Through> = .byIdKeys,
        req: Request,
        db: (any Database)? = nil,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) async throws -> Output
    where

        Model == Output.Model {

            try await delete(
                resolver: resolver,
                req: req,
                db: db,
                using: deleter,
                willDetach: middleware,
                queryModifier: queryModifier,
                relationKeyPath: relationKeyPath
            ).get()
    }
}
