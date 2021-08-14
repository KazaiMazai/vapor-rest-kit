//
//  File.swift
//  
//
//  deleted by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension Model {
    static func deleteRelation<Output, RelatedModel>(
        resolver: ChildPairResolver<Self, RelatedModel>,
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Self == Output.Model {

        req.db.tryTransaction { db in

            try resolver.findWithRelated(req, db, childrenKeyPath, queryModifier)
                .flatMap { (model, related) in relatedResourceMiddleware.handleRelated(model,
                                                                   relatedModel: related,
                                                                   req: req,
                                                                   database: db) }
                .flatMapThrowing { (model, related) in
                    try model.detached(from: related, with: childrenKeyPath) }
                .flatMap { $0.save(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    static func deleteRelation<Output, RelatedModel>(
        resolver: ParentPairResolver<Self, RelatedModel>,
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>

        where
        Output: ResourceOutputModel,
        Self == Output.Model {

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
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    static func deleteRelation<Output, RelatedModel, Through>(
        resolver: SiblingsPairResolver<Self, RelatedModel, Through>,
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>

        where
        Output: ResourceOutputModel,
        Self == Output.Model {

        req.db.tryTransaction { db in

            try resolver.findWithRelated(req, db, siblingKeyPath, queryModifier)
                .flatMap { (model, related) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMap { (model, related) in
                    model.detached(from: related, with: siblingKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req)}
        }
    }
}

