//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.08.2021.
//

import Vapor
import Fluent

struct ChildResolver<Model, RelatedModel>
where
    Model: Fluent.Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Model.IDValue: LosslessStringConvertible {

    let find: (_ req: Request,
               _ db: Database,
               _ keyPath: ChildrenKeyPath<RelatedModel, Model>,
               _ queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<(Model, RelatedModel)>
}

extension ChildResolver {
    static func requireAuth() -> ChildResolver where RelatedModel: Authenticatable {
        ChildResolver(find: Model.findByIdKeyAndAuthRelated)
    }

    static var byIdKeys: ChildResolver {
        ChildResolver(find: Model.findByIdKeys)
    }
}

struct ParentResolver<Model, RelatedModel>
where
    Model: Fluent.Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Model.IDValue: LosslessStringConvertible {

    let find: (_ req: Request,
               _ db: Database,
               _ keyPath: ChildrenKeyPath<Model, RelatedModel>,
               _ queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<(Model, RelatedModel)>
}

extension ParentResolver {
    static func requireAuth() -> ParentResolver where RelatedModel: Authenticatable {
        ParentResolver(find: Model.findByIdKeyAndAuthRelated)
    }

    static var byIdKeys: ParentResolver {
        ParentResolver(find: Model.findByIdKeys)
    }
}


struct SiblingsResolver<Model, RelatedModel, Through>
where
    Model: Fluent.Model,
    Through: Fluent.Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Model.IDValue: LosslessStringConvertible {

    let find: (_ req: Request,
               _ db: Database,
               _ keyPath: SiblingKeyPath<RelatedModel, Model, Through>,
               _ queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<(Model, RelatedModel)>
}

extension SiblingsResolver {
    static func requireAuth() -> SiblingsResolver
    where
        RelatedModel: Authenticatable {

        SiblingsResolver(find: Model.findByIdKeyAndAuthRelated)
    }

    static var byIdKeys: SiblingsResolver {
        SiblingsResolver(find: Model.findByIdKeys)
    }
}

struct ModelResolver<Model>
where
    Model: Fluent.Model,
    Model.IDValue: LosslessStringConvertible {

    let find: (_ req: Request,
               _ db: Database) throws -> EventLoopFuture<Model>
}

extension ModelResolver {
    static func requireAuth() -> ModelResolver where Model: Authenticatable {
        ModelResolver(find: Model.requireAuth)
    }

    static var byIdKeys: ModelResolver {
        ModelResolver(find: Model.findByIdKey)
    }
}

