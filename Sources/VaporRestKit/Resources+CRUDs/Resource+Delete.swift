//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    static func delete<Output>(req: Request, using deleter: DeleteHandler<Self>) throws -> EventLoopFuture<Output> where
        Output: ResourceOutputModel,
        Output.Model == Self {

        req.db.tryTransaction { db in
            try Self.findByIdKey(req, database: db)
                .flatMap { deleter
                    .performDelete($0, req: req, database: db)
                    .transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

extension Model where IDValue: LosslessStringConvertible {
    static func deleteRelated<Output, RelatedModel>(
        req: Request,
        using deleter: DeleteHandler<Self>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try deleteRelated(findWithRelated: Self.findWithRelatedOn,
                      req: req,
                      using: deleter,
                      relatedResourceMiddleware: relatedResourceMiddleware,
                      childrenKeyPath: childrenKeyPath)
    }

    static func deleteRelated<Output, RelatedModel>(
        req: Request,
        using deleter: DeleteHandler<Self>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try deleteRelated(findWithRelated: Self.findWithRelatedOn,
                      req: req,
                      using: deleter,
                      relatedResourceMiddleware: relatedResourceMiddleware,
                      childrenKeyPath: childrenKeyPath)
    }

    static func deleteRelated<Output, RelatedModel, Through>(
        req: Request,
        using deleter: DeleteHandler<Self>,
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

        try deleteRelated(findWithRelated: Self.findWithRelatedOn,
                      req: req,
                      using: deleter,
                      relatedResourceMiddleware: relatedResourceMiddleware,
                      siblingKeyPath: siblingKeyPath)
    }
}

extension Model where IDValue: LosslessStringConvertible {
    static func deleteAuthRelated<Output, RelatedModel>(
        req: Request,
        using deleter: DeleteHandler<Self>,
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

        try deleteRelated(findWithRelated: Self.findWithAuthRelatedOn,
                      req: req,
                      using: deleter,
                      relatedResourceMiddleware: relatedResourceMiddleware,
                      childrenKeyPath: childrenKeyPath)
    }

    static func deleteAuthRelated<Output, RelatedModel>(
        req: Request,
        using deleter: DeleteHandler<Self>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable  {

        try deleteRelated(findWithRelated: Self.findWithAuthRelatedOn,
                      req: req,
                      using: deleter,
                      relatedResourceMiddleware: relatedResourceMiddleware,
                      childrenKeyPath: childrenKeyPath)
    }

    static func deleteAuthRelated<Output, RelatedModel, Through>(
        req: Request,
        using deleter: DeleteHandler<Self>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        Through: Fluent.Model,
        RelatedModel: Authenticatable {

        try deleteRelated(findWithRelated: Self.findWithAuthRelatedOn,
                      req: req,
                      using: deleter,
                      relatedResourceMiddleware: relatedResourceMiddleware,
                      siblingKeyPath: siblingKeyPath)
    }
}


fileprivate extension Model where IDValue: LosslessStringConvertible {

     static func deleteRelated<Output, RelatedModel>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<(Self, RelatedModel)>,
        req: Request,
        using deleter: DeleteHandler<Self>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        req.db.tryTransaction { db in

            try findWithRelated(req, db, childrenKeyPath)
                .flatMap { (model, related) in relatedResourceMiddleware.handleRelated(model,
                                                                   relatedModel: related,
                                                                   req: req,
                                                                   database: db) }
                .flatMap { deleter.performDelete($0.0, req: req, database: db).transform(to: $0.0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    static func deleteRelated<Output, RelatedModel>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<(Self, RelatedModel)>,
        req: Request,
        using deleter: DeleteHandler<Self>,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        req.db.tryTransaction { db in

            try findWithRelated(req, db, childrenKeyPath)
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
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<(Self, RelatedModel)>,
        req: Request,
        using deleter: DeleteHandler<Self>,
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

        req.db.tryTransaction { db in

            try findWithRelated(req, db, siblingKeyPath)
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
