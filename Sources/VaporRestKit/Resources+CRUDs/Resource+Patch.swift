//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func patch<Input, Output>(
        req: Request,
        using: Input.Type,
        queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<Output>
    where
        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Output.Model == Model,
        Input.Model == Output.Model {
        
        try mutate(req: req, using: using, queryModifier: queryModifier)
    }
}

extension RelatedResourceController {
    
    func patch<Input, Output, RelatedModel>(
        resolver: ParentChildResolver<Model, RelatedModel>,
        req: Request,
        using: Input.Type,
        willSave middleware: RelatedResourceMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Model == Output.Model,
        Input.Model == Output.Model {
        
        try mutate(resolver: resolver,
                   req: req,
                   using: using,
                   willSave: middleware,
                   queryModifier: queryModifier,
                   relationKeyPath: relationKeyPath)
    }
    
    func patch<Input, Output, RelatedModel>(
        resolver: ChildParentResolver<Model, RelatedModel>,
        req: Request,
        using: Input.Type,
        willSave middleware: RelatedResourceMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Model == Output.Model,
        Input.Model == Output.Model {
        
        try mutate(resolver: resolver,
                   req: req,
                   using: using,
                   willSave: middleware,
                   queryModifier: queryModifier,
                   relationKeyPath: relationKeyPath)
    }
    
    func patch<Input, Output, RelatedModel, Through>(
        resolver: SiblingsPairResolver<Model, RelatedModel, Through>,
        req: Request,
        using: Input.Type,
        willSave middleware: RelatedResourceMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model>,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where
        
        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
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
