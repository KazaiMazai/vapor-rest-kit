//
//  File.swift
//  
//
//  deleted by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    static func deleteRelation<Output, RelatedModel>(
        req: Request,
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

        try deleteRelation(findRelated: RelatedModel.findByIdKey,
                           req: req, relatedResourceMiddleware: relatedResourceMiddleware,
                           queryModifier: queryModifier,
                           childrenKeyPath: childrenKeyPath)
    }

    static func deleteRelation<Output, RelatedModel>(
        req: Request,
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

        try deleteRelation(findRelated: RelatedModel.findByIdKey,
                           req: req,
                           relatedResourceMiddleware: relatedResourceMiddleware,
                           queryModifier: queryModifier,
                           childrenKeyPath: childrenKeyPath)
    }

    static func deleteRelation<Output, RelatedModel, Through>(
        req: Request,
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

        try deleteRelation(findRelated: RelatedModel.findByIdKey,
                           req: req,
                           relatedResourceMiddleware: relatedResourceMiddleware,
                           queryModifier: queryModifier,
                           siblingKeyPath: siblingKeyPath)
    }
}


extension Model where IDValue: LosslessStringConvertible {
    static func deleteAuthedRelation<Output, RelatedModel>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable {

        try deleteRelation(findRelated: RelatedModel.findAsAuth,
                           req: req,
                           relatedResourceMiddleware: relatedResourceMiddleware,
                           queryModifier: queryModifier,
                           childrenKeyPath: childrenKeyPath)
    }

    static func deleteAuthedRelation<Output, RelatedModel>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable {

        try deleteRelation(findRelated: RelatedModel.findAsAuth,
                           req: req,
                           relatedResourceMiddleware: relatedResourceMiddleware,
                           queryModifier: queryModifier,
                           childrenKeyPath: childrenKeyPath)
    }

    static func deleteAuthedRelation<Output, RelatedModel, Through>(
        req: Request,
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
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable  {

        try deleteRelation(findRelated: RelatedModel.findAsAuth,
                           req: req,
                           relatedResourceMiddleware: relatedResourceMiddleware,
                           queryModifier: queryModifier,
                           siblingKeyPath: siblingKeyPath)
    }
}

fileprivate extension Model where IDValue: LosslessStringConvertible {

    static func deleteRelation<Output, RelatedModel>(
        findRelated: @escaping (_ req: Request, _ db: Database) throws -> EventLoopFuture<RelatedModel>,
        req: Request,
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

            try findRelated(req, db)
                .and(Self.findByIdKey(req, database: db, using: queryModifier))
                .flatMap { relatedResourceMiddleware.handleRelated($0.1,
                                                                   relatedModel: $0.0,
                                                                   req: req,
                                                                   database: db) }
                .flatMapThrowing { (resource, related) in
                    try resource.detached(from: related, with: childrenKeyPath) }
                .flatMap { $0.save(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    static func deleteRelation<Output, RelatedModel>(
        findRelated: @escaping (_ req: Request,
                                _ db: Database) throws -> EventLoopFuture<RelatedModel>,
        req: Request,
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

            try findRelated(req, db)
                .and(Self.findByIdKey(req, database: db, using: queryModifier))
                .flatMap { (related, model) in relatedResourceMiddleware.handleRelated(model,
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
        findRelated: @escaping (_ req: Request, _ db: Database) throws -> EventLoopFuture<RelatedModel>,
        req: Request,
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

            try findRelated(req, db)
                .and(Self.findByIdKey(req, database: db, using: queryModifier))
                .flatMap { (related, model) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMap { (model, related) in
                    model.detached(from: related, with: siblingKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req)}
        }
    }
}



