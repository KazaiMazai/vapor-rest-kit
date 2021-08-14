//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Vapor
import Fluent

extension Model {
    static func readWithCursorPagination<Output>(
        req: Request,
        queryModifier: QueryModifier<Self>?,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Output.Model == Self {

        Self.query(on: req.db)
            .with(queryModifier, for: req)
            .paginateWithCursor(for: req, config: config)
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }
}

extension Model {
    static func readWithCursorPagination<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Self == Output.Model {

        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.query(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in query.with(queryModifier, for: req) }
            .flatMap { $0.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }

    static func readWithCursorPagination<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Self>?,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Self == Output.Model {

        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in try related.query(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in query.with(queryModifier, for: req) }
            .flatMap { $0.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }

    static func readWithCursorPagination<Output, RelatedModel, Through>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Self>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Self == Output.Model {

        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: siblingKeyPath, on: req.db) }
            .flatMapThrowing { query in query.with(queryModifier, for: req) }
            .flatMap { $0.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }
}
