//
//  File.swift
//
//
//  Created by Sergey Kazakov on 07.08.2021.
//

import Vapor
import Fluent

public extension ResourceController {
    func patch<Input, Model>(
        req: Request,
        using: Input.Type,
        queryModifier: QueryModifier<Model> = .empty) async throws -> Output
    where
        Input: ResourcePatchModel,
        Output.Model == Model,
        Input.Model == Output.Model {
        
        try await patch(
            req: req,
            using: Input.self,
            queryModifier: queryModifier
        ).get()
    }
}

public extension RelatedResourceController {
    
    func patch<Input, Model, RelatedModel>(
        resolver: ChildResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) async throws -> Output
    where
        Input: ResourcePatchModel,
        Model == Output.Model,
        Input.Model == Output.Model {
        
        try await patch(
            resolver: resolver,
            req: req,
            using: Input.self,
            willSave: middleware,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
    
    func patch<Input, Model, RelatedModel>(
        resolver: ParentResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) async throws -> Output
    where
        Input: ResourcePatchModel,
        Model == Output.Model,
        Input.Model == Output.Model {
        
        try await patch(
            resolver: resolver,
            req: req,
            using: Input.self,
            willSave: middleware,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
    
    func patch<Input, Model, RelatedModel, Through>(
        resolver: SiblingsResolver<Model, RelatedModel, Through> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willSave middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) async throws -> Output
    where
        Input: ResourcePatchModel,
        Model == Output.Model,
        Input.Model == Output.Model {
            
        try await patch(
            resolver: resolver,
            req: req,
            using: Input.self,
            willSave: middleware,
            queryModifier: queryModifier,
            relationKeyPath: relationKeyPath
        ).get()
    }
}
