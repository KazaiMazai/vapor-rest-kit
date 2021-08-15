//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func getPage<Output>(req: Request,
                         queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<Page<Output>> where
        Output: ResourceOutputModel,
        Output.Model == Model {
        
        try Model
            .query(on: req.db)
            .with(queryModifier, for: req)
            .paginate(for: req)
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
}

extension RelatedResourceController {
    func getPage<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Page<Output>>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.paginate(for: req) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getPage<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Page<Output>>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in try related.queryRelated(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.paginate(for: req) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getPage<Output, RelatedModel, Through>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Page<Output>>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: siblingKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.paginate(for: req) }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
}
