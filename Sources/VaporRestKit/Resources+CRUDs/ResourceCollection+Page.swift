//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func getPage<Model>(req: Request,
                        queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<Page<Output>> where

        Output.Model == Model {
        
        try Model
            .query(on: req.db)
            .with(queryModifier, for: req)
            .paginate(for: req)
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
}

extension RelatedResourceController {
    func getPage<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Page<Output>>
    where

        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: relationKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.paginate(for: req) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getPage<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Page<Output>>
    where

        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in try related.queryRelated(keyPath: relationKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.paginate(for: req) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getPage<Model, RelatedModel, Through>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Page<Output>>
    where

        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: relationKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.paginate(for: req) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
}
