//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    static func read<Output>(req: Request, queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<Output> where
        Output: ResourceOutputModel,
        Output.Model == Self {

        try Self.findByIdKey(req, database: req.db, using: queryModifier)
            .flatMapThrowing { model in try Output(model, req: req) }
    }
}

extension Model where IDValue: LosslessStringConvertible {
    static func readRelated<Output, RelatedModel>(
        req: Request,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try readRelated(findWithRelated: Self.findWithRelatedOn,
                        req: req,
                        queryModifier: queryModifier,
                        childrenKeyPath: childrenKeyPath)
    }

    static func readRelated<Output, RelatedModel>(
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

        try readRelated(findWithRelated: Self.findWithRelatedOn,
                        req: req,
                        relatedResourceMiddleware: relatedResourceMiddleware,
                        queryModifier: queryModifier,
                        childrenKeyPath: childrenKeyPath)
    }

    static func readRelated<Output, RelatedModel, Through>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        Through: Fluent.Model {

        try readRelated(findWithRelated: Self.findWithRelatedOn,
                        req: req,
                        relatedResourceMiddleware: relatedResourceMiddleware,
                        queryModifier: queryModifier,
                        siblingKeyPath: siblingKeyPath)
    }
}


extension Model where IDValue: LosslessStringConvertible {

    static func readAuthRelated<Output, RelatedModel>(
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

        try readRelated(findWithRelated: Self.findWithAuthRelatedOn,
                        req: req,
                        relatedResourceMiddleware: relatedResourceMiddleware,
                        queryModifier: queryModifier,
                        childrenKeyPath: childrenKeyPath)
    }

    static func readAuthRelated<Output, RelatedModel>(
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

        try readRelated(findWithRelated: Self.findWithAuthRelatedOn,
                        req: req,
                        relatedResourceMiddleware: relatedResourceMiddleware,
                        queryModifier: queryModifier,
                        childrenKeyPath: childrenKeyPath)
    }

    static func readAuthRelated<Output, RelatedModel, Through>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable,
        Through: Fluent.Model {

        try readRelated(findWithRelated: Self.findWithAuthRelatedOn,
                        req: req,
                        relatedResourceMiddleware: relatedResourceMiddleware,
                        queryModifier: queryModifier,
                        siblingKeyPath: siblingKeyPath)
    }
}


fileprivate extension Model where IDValue: LosslessStringConvertible {

    static func readRelated<Output, RelatedModel>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>,
                                    _ queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<(Self, RelatedModel)>,
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

        try findWithRelated(req, req.db, childrenKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req) }

    }

    static func readRelated<Output, RelatedModel>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>,
                                    _ queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<(Self, RelatedModel)>,
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

        try findWithRelated(req, req.db, childrenKeyPath, queryModifier)
            .flatMapThrowing {  (model, related) in try Output(model, req: req)}

    }

    static func readRelated<Output, RelatedModel, Through>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>,
                                    _ queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<(Self, RelatedModel)>,
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

        try findWithRelated(req, req.db, siblingKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req) }

    }
}
