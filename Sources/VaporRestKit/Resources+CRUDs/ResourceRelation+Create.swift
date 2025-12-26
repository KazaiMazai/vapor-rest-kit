//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent

public extension RelationsController {
    
    func createRelation<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        db: (any Database)? = nil,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        Model == Output.Model {
        
        (db ?? req.db).tryTransaction { db in
            
            try resolver
                .find(req, db)
                .and(Model.findByIdKey(req, database: db, queryModifier: queryModifier))
                .flatMap { (related, model) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (model, related) in
                    try model.attached(to: related, with: relationKeyPath) }
                .flatMap { model in model.save(on: db).transform(to: model) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
    
    func createRelation<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        db: (any Database)? = nil,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Model == Output.Model {
        
        (db ?? req.db).tryTransaction { db in
            
            try resolver
                .find(req, db)
                .and(Model.findByIdKey(req, database: db, queryModifier: queryModifier))
                .flatMap { (related, model) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (model, related) in
                    try model.attached(to: related, with: relationKeyPath)
                    return related.save(on: db).transform(to: model) }
                .flatMap { $0 }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
    
    func createRelation<Model, RelatedModel, Through>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        db: (any Database)? = nil,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where
        Model == Output.Model {
        
        (db ?? req.db).tryTransaction { db in
            
            try resolver
                .find(req, db)
                .and(Model.findByIdKey(req, database: db, queryModifier: queryModifier))
                .flatMap { (related, model) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMap { (model, related) in
                    model.attached(to: related, with: relationKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req)}
        }
    }
}

//MARK: - Concurrency

public extension RelationsController {
    
    func createRelation<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        db: (any Database)? = nil,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) async throws -> Output
    where
        Model == Output.Model {
        
        try await createRelation(
            resolver: resolver,
            req: req,
            db: db,
            willAttach: middleware,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
    
    func createRelation<Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        db: (any Database)? = nil,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) async throws -> Output
    where
        Model == Output.Model {
        
        try await createRelation(
            resolver: resolver,
            req: req,
            db: db,
            willAttach: middleware,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
    
    func createRelation<Model, RelatedModel, Through>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        db: (any Database)? = nil,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) async throws -> Output
    where
        Model == Output.Model {
        
        try await createRelation(
            resolver: resolver,
            req: req,
            db: db,
            willAttach: middleware,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
}

