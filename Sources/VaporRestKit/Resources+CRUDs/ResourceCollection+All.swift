//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Foundation

import Vapor
import Fluent

public extension ResourceController {
    func getAll<Model>(req: Request,
                        queryModifier: QueryModifier<Model> = .empty) throws -> EventLoopFuture<[Output]>
    where
        Output.Model == Model {
        
        try Model
            .query(on: req.db)
            .with(queryModifier, for: req)
            .all()
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getAll<Model>(req: Request,
                        queryModifier: QueryModifier<Model> = .empty) async throws -> [Output]
    where
        Output.Model == Model {
        
        try await getAll(
            req: req,
            queryModifier: queryModifier
        ).get()
    }
}

public extension RelatedResourceController {
    func getAll<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<[Output]>
    where
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: relationKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.all() }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getAll<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<[Output]>
    where
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in try related.queryRelated(keyPath: relationKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.all() }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
    
    func getAll<Model, RelatedModel, Through>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<[Output]>
    where
        Model == Output.Model {
        
        try resolver
            .find(req, req.db)
            .flatMapThrowing { related in related.queryRelated(keyPath: relationKeyPath, on: req.db) }
            .flatMapThrowing { query in try query.with(queryModifier, for: req) }
            .flatMap { $0.all() }
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
}

//MARK: - Concurrency

public extension RelatedResourceController {
    func getAll<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) async throws -> [Output]
    where
        Model == Output.Model {
        
        try await getAll(
            resolver: resolver,
            req: req,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
    
    func getAll<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) async throws -> [Output]
    where
        Model == Output.Model {
        
        try await getAll(
            resolver: resolver,
            req: req,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
    
    func getAll<Model, RelatedModel, Through>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) async throws -> [Output]
    where
        Model == Output.Model {
        
        try await getAll(
            resolver: resolver,
            req: req,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
}

