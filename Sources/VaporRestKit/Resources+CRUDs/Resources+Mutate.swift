//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07.08.2021.
//

import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    static func mutate<Input, Output>(
        req: Request,
        using: Input.Type,
        queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<Output>
    where
        Input: ResourceMutationModel,
        Output: ResourceOutputModel,
        Output.Model == Self,
        Input.Model == Output.Model {

        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)

        return req.db.tryTransaction { db in
            try Self.findByIdKey(req, database: db, using: queryModifier)
                .flatMap { inputModel.mutate($0, req: req, database: db) }
                .flatMap { model in return model.save(on: db)
                    .flatMapThrowing { try Output(model, req: req) }}
        }
    }
}



extension Model where IDValue: LosslessStringConvertible {
    static func mutateRelated<Input, Output, RelatedModel>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
    where

        Input: ResourceMutationModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try mutateRelated(findWithRelated: Self.findWithRelatedOn,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          childrenKeyPath: childrenKeyPath)
    }

    static func mutateRelated<Input, Output, RelatedModel>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
    where

        Input: ResourceMutationModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try mutateRelated(findWithRelated: Self.findWithRelatedOn,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          childrenKeyPath: childrenKeyPath)
    }

    static func mutateRelated<Input, Output, RelatedModel, Through>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
    where

        Input: ResourceMutationModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        Through: Fluent.Model {

        try mutateRelated(findWithRelated: Self.findWithRelatedOn,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          siblingKeyPath: siblingKeyPath)
    }
}


extension Model where IDValue: LosslessStringConvertible {

    static func mutateAuthRelated<Input, Output, RelatedModel>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
    where

        Input: ResourceMutationModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable {

        try mutateRelated(findWithRelated: Self.findWithAuthRelatedOn,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          childrenKeyPath: childrenKeyPath)
    }

    static func mutateAuthRelated<Input, Output, RelatedModel>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
    where

        Input: ResourceMutationModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable {

        try mutateRelated(findWithRelated: Self.findWithAuthRelatedOn,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          childrenKeyPath: childrenKeyPath)
    }

    static func mutateAuthRelated<Input, Output, RelatedModel, Through>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
    where

        Input: ResourceMutationModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable,
        Through: Fluent.Model {

        try mutateRelated(findWithRelated: Self.findWithAuthRelatedOn,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          siblingKeyPath: siblingKeyPath)
    }
}


fileprivate extension Model where IDValue: LosslessStringConvertible {

    static func mutateRelated<Input, Output, RelatedModel>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>,
                                    _ queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<(Self, RelatedModel)>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
    where

        Input: ResourceMutationModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        return req.db.tryTransaction { db in

            try findWithRelated(req, db, childrenKeyPath, queryModifier)
                .flatMap { (model, related) in inputModel.mutate(model, req: req ,database: db).and(value: related) }
                .flatMap { (model, related) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMapThrowing { try $0.0.attached(to: $0.1, with: childrenKeyPath) }
                .flatMap { $0.save(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    static func mutateRelated<Input, Output, RelatedModel>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>,
                                    _ queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<(Self, RelatedModel)>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
    where

        Input: ResourceMutationModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {


        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        let keyPath = childrenKeyPath
        return req.db.tryTransaction { db in

            try findWithRelated(req, db, childrenKeyPath, queryModifier)
                .flatMap { (model, related) in inputModel.mutate(model, req: req ,database: db).and(value: related) }
                .flatMap { (model, related ) in relatedResourceMiddleware.handleRelated(model,
                                                                                        relatedModel: related,
                                                                                        req: req,
                                                                                        database: db) }
                .flatMap { (model, related) in  model.save(on: db).transform(to: (model, related)) }
                .flatMapThrowing { (model, related) in (try model.attached(to: related, with: keyPath), related) }
                .flatMap { (model, related) in [related.save(on: db), model.save(on: db)]
                    .flatten(on: db.context.eventLoop)
                    .transform(to: model) }
                .flatMapThrowing { try Output($0, req: req)}
        }
    }

    static func mutateRelated<Input, Output, RelatedModel, Through>(
        findWithRelated: @escaping (_ req: Request,
                                    _ db: Database,
                                    _ siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>,
                                    _ queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<(Self, RelatedModel)>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
    where

        Input: ResourceMutationModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Through: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        return req.db.tryTransaction { db in

            try findWithRelated(req, db, siblingKeyPath, queryModifier)
                .flatMap { (model, related) in inputModel.mutate(model, req: req ,database: db).and(value: related) }
                .flatMap { (model, related) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMap { (model, related) in model.save(on: db).transform(to: (model, related)) }
                .flatMap { (model, related) in model.attached(to: related, with: siblingKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}
