//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func getCursorPage<Output>(
        req: Request,
        queryModifier: QueryModifier<Model>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Output.Model == Model {
        
        try Model
            .query(on: req.db)
            .with(queryModifier, for: req)
            .paginateWithCursor(for: req, config: config)
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
}

extension RelatedResourceController {
    func getCursorPage<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { query in query.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getCursorPage<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in try related.queryRelated(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { query in query.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getCursorPage<Output, RelatedModel, Through>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: siblingKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { query in query.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
}
