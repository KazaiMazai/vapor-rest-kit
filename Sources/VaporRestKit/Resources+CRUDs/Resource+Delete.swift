//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func delete<Output>(req: Request,
                        using deleter: DeleteHandler<Model>,
                        queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<Output> where
        Output: ResourceOutputModel,
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

extension RelatedResourceController {

    func delete<Output, RelatedModel>(
        resolver: ParentChildResolver<Model, RelatedModel>,
        req: Request,
        using deleter: DeleteHandler<Model>,
        willDetach middleware: RelatedResourceMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
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

    func delete<Output, RelatedModel>(
        resolver: ChildParentResolver<Model, RelatedModel>,
        req: Request,
        using deleter: DeleteHandler<Model>,
        willDetach middleware: RelatedResourceMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
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

    func delete<Output, RelatedModel, Through>(
        resolver: SiblingsPairResolver<Model, RelatedModel, Through>,
        req: Request,
        using deleter: DeleteHandler<Model>,
        willDetach middleware: RelatedResourceMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
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
