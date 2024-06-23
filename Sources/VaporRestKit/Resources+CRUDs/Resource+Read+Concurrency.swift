//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.06.2024.
//

import Vapor
import Fluent

public extension ResourceController {
    func read<Model>(req: Request,
                      queryModifier: QueryModifier<Model> = .empty) async throws -> Output
    where
        Output.Model == Model {

            try await read(
                req: req,
                queryModifier: queryModifier
            ).get()
    }
}

public extension RelatedResourceController {
    func read<Model, RelatedModel>(
        resolver: ChildResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) async throws -> Output
    where
        Model == Output.Model {

            try await read(
                resolver: resolver,
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: relationKeyPath
            ).get()
    }

    func read<Model, RelatedModel>(
        resolver: ParentResolver<Model, RelatedModel> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) async throws -> Output
    where
        Model == Output.Model {

            try await read(
                resolver: resolver,
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: relationKeyPath
            ).get()
        }

    func read<Model, RelatedModel, Through>(
        resolver: SiblingsResolver<Model, RelatedModel, Through> = .byIdKeys,
        req: Request,
        queryModifier: QueryModifier<Model> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) async throws -> Output
    where
        Model == Output.Model {

            try await read(
                resolver: resolver,
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: relationKeyPath
            ).get()
    }
}

