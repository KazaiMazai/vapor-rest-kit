//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    static func read<Output>(req: Request,
                             queryModifier: QueryModifier<Self>?) throws -> EventLoopFuture<Output> where
        Output: ResourceOutputModel,
        Output.Model == Self {

        try Self.findByIdKey(req, database: req.db, using: queryModifier)
            .flatMapThrowing { model in try Output(model, req: req) }
    }
}

extension Model where IDValue: LosslessStringConvertible {
    static func readRelated<Output, RelatedModel>(
        resolver: ChildPairResolver<Self, RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
    where
        Output: ResourceOutputModel,
        Self == Output.Model {

        try resolver
            .findWithRelated(req, req.db, childrenKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req) }

    }

    static func readRelated<Output, RelatedModel>(
        resolver: ParentPairResolver<Self, RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Output: ResourceOutputModel,
        Self == Output.Model {

        try resolver
            .findWithRelated(req, req.db, childrenKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req)}

    }

    static func readRelated<Output, RelatedModel, Through>(
        resolver: SiblingsPairResolver<Self, RelatedModel, Through>,
        req: Request,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
    where
        Output: ResourceOutputModel,
        Self == Output.Model {

        try resolver
            .findWithRelated(req, req.db, siblingKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req) }

    }
}

