//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent

extension RelationsController {
    
    func createRelation<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        willAttach middleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        req.db.tryTransaction { db in
            
            try resolver
                .find(req, db)
                .and(Model.findByIdKey(req, database: db, queryModifier: queryModifier))
                .flatMap { (related, model) in middleware.handleRelated(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (model, related) in
                    try model.attached(to: related, with: childrenKeyPath) }
                .flatMap { model in model.save(on: db).transform(to: model) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
    
    func createRelation<Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        willAttach middleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Model>,
        childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        req.db.tryTransaction { db in
            
            try resolver
                .find(req, db)
                .and(Model.findByIdKey(req, database: db, queryModifier: queryModifier))
                .flatMap { (related, model) in middleware.handleRelated(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (model, related) in
                    try model.attached(to: related, with: childrenKeyPath)
                    return related.save(on: db).transform(to: model) }
                .flatMap { $0 }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
    
    func createRelation<Output, RelatedModel, Through>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        willAttach middleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Model>,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where
        
        Output: ResourceOutputModel,
        Model == Output.Model {
        
        req.db.tryTransaction { db in
            
            try resolver
                .find(req, db)
                .and(Model.findByIdKey(req, database: db, queryModifier: queryModifier))
                .flatMap { (related, model) in middleware.handleRelated(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMap { (model, related) in
                    model.attached(to: related, with: siblingKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req)}
        }
    }
}
