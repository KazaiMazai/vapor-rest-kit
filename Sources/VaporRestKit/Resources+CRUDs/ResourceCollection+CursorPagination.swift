//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func readWithCursorPagination<Output>(
        req: Request,
        queryModifier: QueryModifier<Model>?,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Output.Model == Model {

        Model.query(on: req.db)
            .with(queryModifier, for: req)
            .paginateWithCursor(for: req, config: config)
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }
}

extension ResourceController {
    func readWithCursorPagination<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {

        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.query(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in query.with(queryModifier, for: req) }
            .flatMap { $0.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }

    func readWithCursorPagination<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>?,
        childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {

        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in try related.query(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in query.with(queryModifier, for: req) }
            .flatMap { $0.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }

    func readWithCursorPagination<Output, RelatedModel, Through>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>,
        config: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {

        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: siblingKeyPath, on: req.db) }
            .flatMapThrowing { query in query.with(queryModifier, for: req) }
            .flatMap { $0.paginateWithCursor(for: req, config: config) }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }
}
