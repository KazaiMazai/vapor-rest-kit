//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23/06/2024.
//

import Vapor
import Fluent

public extension ResourceController {
    func delete<Model>(
        req: Request,
        using deleter: Deleter<Model> = .defaultDeleter(),
        queryModifier: QueryModifier<Model> = .empty) async throws -> Output
    where
        Output.Model == Model {

        try await delete(
            req: req,
            using: deleter,
            queryModifier: queryModifier
        ).get()
    }
}

public extension RelatedResourceController {

    func delete<Model, RelatedModel>(
        resolver: ChildResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) async throws -> Output
    where
        Model == Output.Model {

            try await delete(
                resolver: resolver,
                req: req,
                using: deleter,
                willDetach: middleware,
                queryModifier: queryModifier,
                relationKeyPath: relationKeyPath
            ).get()
    }

    func delete<Model, RelatedModel>(
        resolver: ParentResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) async throws -> Output
    where
        Model == Output.Model {

            try await delete(
                resolver: resolver,
                req: req,
                using: deleter,
                willDetach: middleware,
                queryModifier: queryModifier,
                relationKeyPath: relationKeyPath
            ).get()
    }

    func delete<Model, RelatedModel, Through>(
        resolver: SiblingsResolver<Model, RelatedModel, Through> = .byIdKeys,
        req: Request,
        using deleter: Deleter<Model> = .defaultDeleter(),
        willDetach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) async throws -> Output
    where

        Model == Output.Model {

            try await delete(
                resolver: resolver,
                req: req,
                using: deleter,
                willDetach: middleware,
                queryModifier: queryModifier,
                relationKeyPath: relationKeyPath
            ).get()
    }
}
