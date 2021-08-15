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
            try Model.findByIdKey(req, database: db, queryModifier: queryModifier)
                .flatMap { deleter
                    .performDelete($0, req: req, database: db)
                    .transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

extension RelatedResourceController {

    func delete<Output, RelatedModel>(
        resolver: ChildPairResolver<Model, RelatedModel>,
        req: Request,
        using deleter: DeleteHandler<Model>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Model == Output.Model {

        req.db.tryTransaction { db in

            try resolver.findWithRelated(req, db, childrenKeyPath, queryModifier)
                .flatMap { (model, related) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMap { deleter.performDelete($0.0, req: req, database: db).transform(to: $0.0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    func delete<Output, RelatedModel>(
        resolver: ParentPairResolver<Model, RelatedModel>,
        req: Request,
        using deleter: DeleteHandler<Model>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Model == Output.Model {

        req.db.tryTransaction { db in

            try resolver.findWithRelated(req, db, childrenKeyPath, queryModifier)
                .flatMap { (model, related) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMapThrowing { (model, related) in
                    try model.detached(from: related, with: childrenKeyPath)
                    return related.save(on: db).transform(to: model) }
                .flatMap { $0 }
                .flatMap { deleter
                    .performDelete($0, req: req, database: db)
                    .transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    func delete<Output, RelatedModel, Through>(
        resolver: SiblingsPairResolver<Model, RelatedModel, Through>,
        req: Request,
        using deleter: DeleteHandler<Model>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Model>,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Model == Output.Model {

        req.db.tryTransaction { db in

            try resolver.findWithRelated(req, db, siblingKeyPath, queryModifier)
                .flatMap { (model, related) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMap { (model, related) in model.detached(from: related, with: siblingKeyPath, on: db) }
                .flatMap { deleter
                    .performDelete($0, req: req, database: db)
                    .transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}
