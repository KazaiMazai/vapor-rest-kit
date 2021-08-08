//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07.08.2021.
//


import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    static func update<Input, Output>(req: Request, using: Input.Type) throws -> EventLoopFuture<Output> where
        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Output.Model == Self,
        Input.Model == Output.Model,
        Output.Model: ResourceOutputModel {

        try mutate(req: req, using: using)
    }
}

extension Model where IDValue: LosslessStringConvertible {

    static func updateRelated<Input, Output, RelatedModel>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
        where

        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        Output.Model: ResourceOutputModel,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try mutateRelated(req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          childrenKeyPath: childrenKeyPath)
    }

    static func updateRelated<Input, Output, RelatedModel>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
        where

        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        Output.Model: ResourceOutputModel,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        try mutateRelated(req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          childrenKeyPath: childrenKeyPath)
    }

    static func updateRelated<Input, Output, RelatedModel, Through>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
        where

        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        Output.Model: ResourceOutputModel,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        Through: Fluent.Model {

        try mutateRelated(req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          siblingKeyPath: siblingKeyPath)
    }
}


extension Model where IDValue: LosslessStringConvertible {

    static func updateAuthRelated<Input, Output, RelatedModel>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
        where

        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        Output.Model: ResourceOutputModel,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable {

        try mutateAuthRelated(req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          childrenKeyPath: childrenKeyPath)
    }

    static func updateAuthRelated<Input, Output, RelatedModel>(
        findRelated: (_ req: Request, _ db: Database) throws -> EventLoopFuture<RelatedModel>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
        where

        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        Output.Model: ResourceOutputModel,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable {

        try mutateAuthRelated(req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          childrenKeyPath: childrenKeyPath)
    }

    static func updateAuthRelated<Input, Output, RelatedModel, Through>(
        findRelated: (_ req: Request, _ db: Database) throws -> EventLoopFuture<RelatedModel>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
        where

        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        Output.Model: ResourceOutputModel,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable {

        try mutateAuthRelated(req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          siblingKeyPath: siblingKeyPath)
    }
}
