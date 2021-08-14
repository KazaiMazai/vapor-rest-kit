//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Foundation

import Vapor
import Fluent

extension ResourceController {
    static func readAll<Output>(req: Request,
                                queryModifier: QueryModifier<Model>?) throws -> EventLoopFuture<[Output]> where
        Output: ResourceOutputModel,
        Output.Model == Model {

        Model.query(on: req.db)
            .with(queryModifier, for: req)
            .all()
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }
}

extension ResourceController {
    static func readAllRelated<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<[Output]>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {

        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.query(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in query.with(queryModifier, for: req) }
            .flatMap { $0.all() }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }

    static func readAllRelated<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>?,
        childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<[Output]>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {

        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in try related.query(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in query.with(queryModifier, for: req) }
            .flatMap { $0.all() }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }

    static func readAllRelated<Output, RelatedModel, Through>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<[Output]>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {

        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: siblingKeyPath, on: req.db) }
            .flatMapThrowing { query in query.with(queryModifier, for: req) }
            .flatMap { $0.all() }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }
}

//
//struct CollectionIterator<Model: FluentKit.Model> {
//
//    let fetch: (_ req: Request,
//               _ queryBuilder: QueryBuilder<Model>) throws -> EventLoopFuture<CollectionIteratorResult<Model>>
//}
//
//
//extension CollectionIterator {
//    static func all() -> CollectionIterator<Model> {
//        CollectionIterator<Model> { req, queryBuilder in
//            queryBuilder
//                .all()
//                .map { CollectionIteratorResult.all($0) }
//        }
//    }
//
//    static func paginate() -> CollectionIterator<Model> {
//        CollectionIterator<Model> { req, queryBuilder in
//            queryBuilder
//                .paginate(for: req)
//                .map { CollectionIteratorResult.page($0) }
//        }
//    }
//
//    static func paginateWithCursor(config: CursorPaginationConfig) -> CollectionIterator<Model> {
//        CollectionIterator<Model> { req, queryBuilder in
//            queryBuilder
//                .paginateWithCursor(for: req, config: config)
//                .map { CollectionIteratorResult.cursorPage($0) }
//        }
//    }
//}
//
//enum CollectionIteratorResult<Model: Codable> {
//    case all([Model])
//    case page(Page<Model>)
//    case cursorPage(CursorPage<Model>)
//}
