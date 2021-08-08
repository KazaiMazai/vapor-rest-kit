//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    static func read<Output>(req: Request) throws -> EventLoopFuture<Output> where
        Output: ResourceOutputModel,
        Output.Model == Self {

        try Self.findByIdKey(req, database: req.db)
            .flatMapThrowing { model in try Output(model, req: req) }
    }
}

extension Model where IDValue: LosslessStringConvertible {
    static func readRelated<Output, RelatedModel>(
        req: Request,
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
                        childrenKeyPath: childrenKeyPath)
    }

    static func readRelated<Output, RelatedModel>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
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
                        childrenKeyPath: childrenKeyPath)
    }

    static func readRelated<Output, RelatedModel, Through>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
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
                        siblingKeyPath: siblingKeyPath)
    }
}


extension Model where IDValue: LosslessStringConvertible {

    static func readAuthRelated<Output, RelatedModel>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
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
                        childrenKeyPath: childrenKeyPath)
    }

    static func readAuthRelated<Output, RelatedModel>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
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
                        childrenKeyPath: childrenKeyPath)
    }

    static func readAuthRelated<Output, RelatedModel, Through>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
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
                        siblingKeyPath: siblingKeyPath)
    }
}


fileprivate extension Model where IDValue: LosslessStringConvertible {

    static func readRelated<Output, RelatedModel>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<(Self, RelatedModel)>,
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try findWithRelated(req, req.db, childrenKeyPath)
            .flatMapThrowing { (model, related) in try Output(model, req: req) }

    }

    static func readRelated<Output, RelatedModel>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<(Self, RelatedModel)>,
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
    where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,

        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try findWithRelated(req, req.db, childrenKeyPath)
            .flatMapThrowing {  (model, related) in try Output(model, req: req)}

    }

    static func readRelated<Output, RelatedModel, Through>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<(Self, RelatedModel)>,
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
    where


        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Through: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,

        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try findWithRelated(req, req.db, siblingKeyPath)
            .flatMapThrowing { (model, related) in try Output(model, req: req) }

    }
}
