//
//  File.swift
//  
//
//  deleted by Sergey Kazakov on 08.08.2021.
//

import Vapor
import Fluent

extension RelationsController {
    func deleteRelation<Output, RelatedModel>(
        resolver: ParentChildResolver<Model, RelatedModel>,
        req: Request,
        willDetach middleware: RelatedResourceMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        req.db.tryTransaction { db in
            
            try resolver
                .find(req, db, relationKeyPath, queryModifier)
                .flatMap { (model, related) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (model, related) in
                    try model.detached(from: related, with: relationKeyPath) }
                .flatMap { $0.save(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
    
    func deleteRelation<Output, RelatedModel>(
        resolver: ChildParentResolver<Model, RelatedModel>,
        req: Request,
        willDetach middleware: RelatedResourceMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        req.db.tryTransaction { db in
            
            try resolver
                .find(req, db, relationKeyPath, queryModifier)
                .flatMap { (model, related) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (model, related) in
                    try model.detached(from: related, with: relationKeyPath)
                    return related.save(on: db).transform(to: model) }
                .flatMap { $0 }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
    
    func deleteRelation<Output, RelatedModel, Through>(
        resolver: SiblingsPairResolver<Model, RelatedModel, Through>,
        req: Request,
        willDetach middleware: RelatedResourceMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    
    where
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        req.db.tryTransaction { db in
            
            try resolver
                .find(req, db, relationKeyPath, queryModifier)
                .flatMap { (model, related) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMap { (model, related) in
                    model.detached(from: related, with: relationKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req)}
        }
    }
}

