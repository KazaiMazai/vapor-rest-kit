//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23/06/2024.
//

import Vapor
import Fluent

public extension ResourceController {
    
    func create<Input, Model>(
        req: Request,
        using: Input.Type) async throws -> Output
    where
        Input: ResourceUpdateModel,
        Output.Model == Model,
        Input.Model == Output.Model {
            
            try await create(req: req, using: Input.self).get()
        }
}

public extension RelatedResourceController {
    func create<Input, Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) async throws -> Output
    where
        Input: ResourceUpdateModel,
        Model == Output.Model,
        Input.Model == Output.Model {

            try await create(
                resolver: resolver,
                req: req, using: Input.self,
                willAttach: middleware,
                relationKeyPath: relationKeyPath
            ).get()
    }

    func create<Input, Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) async throws -> Output
    where
        Input: ResourceUpdateModel,
        Model == Output.Model,
        Input.Model == Output.Model {

            try await create(
                resolver: resolver,
                req: req, using: Input.self,
                willAttach: middleware,
                relationKeyPath: relationKeyPath
            ).get()
    }

    func create<Input, Model, RelatedModel, Through>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) async throws -> Output
    where
        Input: ResourceUpdateModel,
        Model == Output.Model,
        Input.Model == Output.Model,
        Through: Fluent.Model {

            try await create(
                resolver: resolver,
                req: req, using: Input.self,
                willAttach: middleware,
                relationKeyPath: relationKeyPath
            ).get()
    }
}
