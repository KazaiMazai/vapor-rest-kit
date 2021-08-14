//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent

extension Model {

    static func createRelation<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model {

        req.db.tryTransaction { db in

            try resolver.find(req, db)
                .and(Self.findByIdKey(req, database: db, using: queryModifier))
                .flatMap { relatedResourceMiddleware.handleRelated($0.1,
                                                                   relatedModel: $0.0,
                                                                   req: req,
                                                                   database: db) }
                .flatMapThrowing { (resource, related) in
                    try resource.attached(to: related, with: childrenKeyPath) }
                .flatMap { $0.save(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    static func createRelation<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model {

        req.db.tryTransaction { db in

            try resolver.find(req, db)
                .and(Self.findByIdKey(req, database: db, using: queryModifier))
                .flatMap { (related, model) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMapThrowing { (model, related) in
                    try model.attached(to: related, with: childrenKeyPath)
                    return related.save(on: db).transform(to: model) }
                .flatMap { $0 }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    static func createRelation<Output, RelatedModel, Through>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model {

        req.db.tryTransaction { db in

            try resolver.find(req, db)
                .and(Self.findByIdKey(req, database: db, using: queryModifier))
                .flatMap { (related, model) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMap { (model, related) in
                    model.attached(to: related, with: siblingKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req)}
        }
    }
}