//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07.08.2021.
//

import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    static func patch<Input, Output>(
        req: Request,
        using: Input.Type,
        queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<Output>
    where
        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Output.Model == Self,
        Input.Model == Output.Model {

        try mutate(req: req, using: using, queryModifier: queryModifier)
    }
}

extension Model {

    static func patchRelated<Input, Output, RelatedModel>(
        resolver: ChildPairResolver<Self, RelatedModel>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
    where
        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Self == Output.Model,
        Input.Model == Output.Model {

        try mutateRelated(resolver: resolver,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          childrenKeyPath: childrenKeyPath)
    }

    static func patchRelated<Input, Output, RelatedModel>(
        resolver: ParentPairResolver<Self, RelatedModel>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
        where

        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Self == Output.Model,
        Input.Model == Output.Model {

        try mutateRelated(resolver: resolver,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          childrenKeyPath: childrenKeyPath)
    }

    static func patchRelated<Input, Output, RelatedModel, Through>(
        resolver: SiblingsPairResolver<Self, RelatedModel, Through>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
        where

        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Self == Output.Model,
        Input.Model == Output.Model {

        try mutateRelated(resolver: resolver,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          siblingKeyPath: siblingKeyPath)
    }
}
