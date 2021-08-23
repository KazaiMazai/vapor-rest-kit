//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func getCursorPage<Model>(
        req: Request,
        queryModifier: QueryModifier<Model>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where

        Output.Model == Model {
        
        try Model
            .query(on: req.db)
            .with(queryModifier, for: req)
            .paginateWithCursor(for: req, config: config)
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
}

extension RelatedResourceController {
    func getCursorPage<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where

        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: relationKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { query in query.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getCursorPage<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where

        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in try related.queryRelated(keyPath: relationKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { query in query.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getCursorPage<Model, RelatedModel, Through>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where

        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: relationKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { query in query.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
}
