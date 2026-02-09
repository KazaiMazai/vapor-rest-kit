//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func mutate<Input, Model>(
        resolver: Resolver<Model> = .byIdKeys,
        req: Request,
        db: (any Database)?,
        using: Input.Type,
        queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<Output>
    where
        Input: ResourceMutationModel,
        Output.Model == Model,
        Input.Model == Output.Model {
        
        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        
        return (db ?? req.db).tryTransaction { db in
            try resolver
                .find(req, req.db, queryModifier)
                .flatMap { inputModel.mutate($0, req: req, database: db) }
                .flatMap { model in return model.save(on: db).transform(to: model) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

extension RelatedResourceController {
    
    func mutate<Input, Model, RelatedModel>(
        resolver: ChildResolver<Model, RelatedModel>,
        req: Request,
        db: (any Database)?,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        Input: ResourceMutationModel,
        Model == Output.Model,
        Model == Input.Model {
        
        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        return (db ?? req.db).tryTransaction { db in
            
            try resolver
                .find(req, db, relationKeyPath, queryModifier)
                .flatMap { (model, related) in inputModel.mutate(model, req: req, database: db).and(value: related) }
                .flatMap { (model, related) in middleware.handle(model,
                                                                 relatedModel: related,
                                                                 req: req,
                                                                 database: db) }
                .flatMapThrowing { (model, related) in try model.attached(to: related, with: relationKeyPath) }
                .flatMap { model in model.save(on: db).transform(to: model) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
    
    func mutate<Input, Model, RelatedModel>(
        resolver: ParentResolver<Model, RelatedModel>,
        req: Request,
        db: (any Database)?,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Input: ResourceMutationModel,
        Model == Output.Model,
        Model == Input.Model {

        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        let keyPath = relationKeyPath
        return (db ?? req.db).tryTransaction { db in
            
            try resolver
                .find(req, db, relationKeyPath, queryModifier)
                .flatMap { (model, related) in inputModel.mutate(model, req: req ,database: db).and(value: related) }
                .flatMap { (model, related ) in middleware.handle(model,
                                                                  relatedModel: related,
                                                                  req: req,
                                                                  database: db) }
                .flatMap { (model, related) in  model.save(on: db).transform(to: (model, related)) }
                .flatMapThrowing { (model, related) in (try model.attached(to: related, with: keyPath), related) }
                .flatMap { (model, related) in
                    [related.save(on: db), model.save(on: db)]
                        .flatten(on: db.context.eventLoop)
                        .transform(to: model) }
                .flatMapThrowing { try Output($0, req: req)}
        }
    }
    
    func mutate<Input, Model, RelatedModel, Through>(
        resolver: SiblingsResolver<Model, RelatedModel, Through>,
        req: Request,
        db: (any Database)?,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where
        Input: ResourceMutationModel,
        Model == Output.Model,
        Model == Input.Model {
        
        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        return (db ?? req.db).tryTransaction { db in
            
            try resolver
                .find(req, db, relationKeyPath, queryModifier)
                .flatMap { (model, related) in inputModel.mutate(model, req: req ,database: db).and(value: related) }
                .flatMap { (model, related) in middleware.handle(model,
                                                                 relatedModel: related,
                                                                 req: req,
                                                                 database: db) }
                .flatMap { (model, related) in model.save(on: db).transform(to: (model, related)) }
                .flatMap { (model, related) in model.attached(to: related, with: relationKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}
