//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07.08.2021.
//


import Vapor
import Fluent

extension ResourceController {
    func update<Input, Model>(
        req: Request,
        using: Input.Type,
        queryModifier: QueryModifier<Model> = .empty) throws -> EventLoopFuture<Output>
    where
        Input: ResourceUpdateModel,
        Output.Model == Model,
        Input.Model == Output.Model {
        
        try mutate(req: req, using: using, queryModifier: queryModifier)
    }
}

extension RelatedResourceController {
    
    func update<Input, Model, RelatedModel>(
        resolver: ChildResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        Input: ResourceUpdateModel,
        Model == Output.Model,
        Input.Model == Output.Model  {
        
        try mutate(resolver: resolver,
                   req: req,
                   using: using,
                   willSave: middleware,
                   queryModifier: queryModifier,
                   relationKeyPath: relationKeyPath)
    }
    
    func update<Input, Model, RelatedModel>(
        resolver: ParentResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Input: ResourceUpdateModel,
        Model == Output.Model,
        Input.Model == Output.Model {
        
        try mutate(resolver: resolver,
                   req: req,
                   using: using,
                   willSave: middleware,
                   queryModifier: queryModifier,
                   relationKeyPath: relationKeyPath)
    }
    
    func update<Input, Model, RelatedModel, Through>(
        resolver: SiblingsResolver<Model, RelatedModel, Through> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where        
        Input: ResourceUpdateModel,
        Model == Output.Model,
        Input.Model == Output.Model {
        
        try mutate(resolver: resolver,
                   req: req,
                   using: using,
                   willSave: middleware,
                   queryModifier: queryModifier,
                   relationKeyPath: relationKeyPath)
    }
}
