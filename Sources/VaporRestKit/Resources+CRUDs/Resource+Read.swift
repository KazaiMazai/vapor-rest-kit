//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func read<Model>(req: Request,
                      queryModifier: QueryModifier<Model> = .empty) throws -> EventLoopFuture<Output>
    where
        Output.Model == Model {

        try Model
            .findByIdKey(req, database: req.db, queryModifier: queryModifier)
            .flatMapThrowing { model in try Output(model, req: req) }
    }
}

extension RelatedResourceController {
    func read<Model, RelatedModel>(
        resolver: ChildResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        Model == Output.Model {

        try resolver
            .find(req, req.db, relationKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req) }
    }

    func read<Model, RelatedModel>(
        resolver: ParentResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Model == Output.Model {

        try resolver
            .find(req, req.db, relationKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req)}
    }

    func read<Model, RelatedModel, Through>(
        resolver: SiblingsResolver<Model, RelatedModel, Through> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where
        Model == Output.Model {

        try resolver
            .find(req, req.db, relationKeyPath, queryModifier)
            .flatMapThrowing { (model, related) in try Output(model, req: req) }
    }
}

