//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    static func delete<Output>(req: Request,
                               using deleter: DeleteHandler<Self>,
                               queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<Output> where
        Output: ResourceOutputModel,
        Output.Model == Self {

        req.db.tryTransaction { db in
            try Self.findByIdKey(req, database: db, using: queryModifier)
                .flatMap { deleter
                    .performDelete($0, req: req, database: db)
                    .transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

extension Model where IDValue: LosslessStringConvertible {

     static func deleteRelated<Output, RelatedModel>(
        resolver: ChildPairResolver<Self, RelatedModel>,
        req: Request,
        using deleter: DeleteHandler<Self>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

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

    static func deleteRelated<Output, RelatedModel>(
        resolver: ParentPairResolver<Self, RelatedModel>,
        req: Request,
        using deleter: DeleteHandler<Self>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

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

    static func deleteRelated<Output, RelatedModel, Through>(
        resolver: SiblingsPairResolver<Self, RelatedModel, Through>,
        req: Request,
        using deleter: DeleteHandler<Self>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Through: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

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
