//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Vapor
import Fluent

public extension ResourceController {
    func getPage<Model>(
        req: Request,
        queryModifier: QueryModifier<Model> = .empty) throws -> EventLoopFuture<Page<Output>>
    where
        Output.Model == Model {
        
        try Model
            .query(on: req.db)
            .with(queryModifier, for: req)
            .paginate(for: req)
            .flatMapThrowing { collection in try collection.map { try Output($0, req: req) } }
    }
}

public extension RelatedResourceController {
    func getPage<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
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
        queryModifier: QueryModifier<Model> = .empty,
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
        queryModifier: QueryModifier<Model> = .empty,
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

//MARK: - Concurrency

public extension ResourceController {
    func getPage<Model>(
        req: Request,
        queryModifier: QueryModifier<Model> = .empty) async throws -> Page<Output>
    where
        Output.Model == Model {
        
        try await getPage(req: req, queryModifier: queryModifier).get()
    }
}

public extension RelatedResourceController {
    func getPage<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) async throws -> Page<Output>
    where
        Model == Output.Model {
        
        try await getPage(
            resolver: resolver,
            req: req,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
    
    func getPage<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) async throws -> Page<Output>
    where
        Model == Output.Model {
        
        try await getPage(
            resolver: resolver,
            req: req,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
    
    func getPage<Model, RelatedModel, Through>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) async throws -> Page<Output>
    where
        Model == Output.Model {
        
        try await getPage(
            resolver: resolver,
            req: req,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
}
