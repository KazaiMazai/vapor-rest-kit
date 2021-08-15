//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func read<Output>(req: Request,
                      queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<Output> where
        Output: ResourceOutputModel,
        Output.Model == Model {

        try Model
            .findByIdKey(req, database: req.db, queryModifier: queryModifier)
            .flatMapThrowing { model in try Output(model, req: req) }
    }
}

extension RelatedResourceController {
    func read<Output, RelatedModel>(
        resolver: ChildPairResolver<Model, RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {

        try resolver
            .findWithRelated(req, req.db, childrenKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req) }

    }

    func read<Output, RelatedModel>(
        resolver: ParentPairResolver<Model, RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {

        try resolver
            .findWithRelated(req, req.db, childrenKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req)}

    }

    func read<Output, RelatedModel, Through>(
        resolver: SiblingsPairResolver<Model, RelatedModel, Through>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {

        try resolver
            .findWithRelated(req, req.db, siblingKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req) }

    }
}

