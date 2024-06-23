//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07.08.2021.
//


import Vapor
import Fluent

public extension ResourceController {
    func update<Input, Model>(
        req: Request,
        using: Input.Type,
        queryModifier: QueryModifier<Model> = .empty) async throws -> Output
    where
        Input: ResourceUpdateModel,
        Output.Model == Model,
        Input.Model == Output.Model {
        
            try await update(req: req, using: using, queryModifier: queryModifier).get()
    }
}

public extension RelatedResourceController {
    
    func update<Input, Model, RelatedModel>(
        resolver: ChildResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) async throws -> Output
    where
    Input: ResourceUpdateModel,
    Model == Output.Model,
    Input.Model == Output.Model  {
        
        try await update(
            resolver: resolver,
            req: req,
            using: using,
            willSave: middleware,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
    
    func update<Input, Model, RelatedModel>(
        resolver: ParentResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) async throws -> Output
    where
        Input: ResourceUpdateModel,
        Model == Output.Model,
        Input.Model == Output.Model {
        
            try await update(
                resolver: resolver,
                req: req,
                using: using,
                willSave: middleware,
                queryModifier: queryModifier,
                relationKeyPath: relationKeyPath
            ).get()
        }
    
    func update<Input, Model, RelatedModel, Through>(
        resolver: SiblingsResolver<Model, RelatedModel, Through> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) async throws -> Output
    where
    Input: ResourceUpdateModel,
    Model == Output.Model,
    Input.Model == Output.Model {
        
        try await update(
            resolver: resolver,
            req: req,
            using: using,
            willSave: middleware,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
}
