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
    func readAll<Output>(req: Request,
                         queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<[Output]> where
        Output: ResourceOutputModel,
        Output.Model == Model {
        
        try Model.query(on: req.db)
            .with(queryModifier, for: req)
            .all()
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }
}

extension RelatedResourceController {
    func readAll<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<[Output]>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.query(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.all() }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }
    
    func readAll<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<[Output]>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in try related.query(keyPath: childrenKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.all() }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }
    
    func readAll<Output, RelatedModel, Through>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        queryModifier: QueryModifier<Model>,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<[Output]>
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: siblingKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.all() }
            .flatMapThrowing { try $0.map { try Output($0, req: req) } }
    }
}

