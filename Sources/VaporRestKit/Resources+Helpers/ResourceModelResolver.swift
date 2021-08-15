//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.08.2021.
//

import Vapor
import Fluent

struct ParentChildResolver<Model, RelatedModel>
where
    Model: Fluent.Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Model.IDValue: LosslessStringConvertible {

    let find: (_ req: Request,
               _ db: Database,
               _ childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
               _ queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<(Model, RelatedModel)>
}

extension ParentChildResolver {
    static func requireAuth() -> ParentChildResolver where RelatedModel: Authenticatable {
        ParentChildResolver(find: Model.findByIdKeyAndAuthRelated)
    }

    static func byIdKeys() -> ParentChildResolver {
        ParentChildResolver(find: Model.findByIdKeys)
    }
}

struct ChildParentResolver<Model, RelatedModel>
where
    Model: Fluent.Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Model.IDValue: LosslessStringConvertible {

    let find: (_ req: Request,
               _ db: Database,
               _ childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
               _ queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<(Model, RelatedModel)>
}

extension ChildParentResolver {
    static func requireAuth() -> ChildParentResolver where RelatedModel: Authenticatable {
        ChildParentResolver(find: Model.findByIdKeyAndAuthRelated)
    }

    static func byIdKeys() -> ChildParentResolver {
        ChildParentResolver(find: Model.findByIdKeys)
    }
}


struct SiblingsPairResolver<Model, RelatedModel, Through>
where
    Model: Fluent.Model,
    Through: Fluent.Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Model.IDValue: LosslessStringConvertible {

    let find: (_ req: Request,
               _ db: Database,
               _ siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>,
               _ queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<(Model, RelatedModel)>
}

extension SiblingsPairResolver {
    static func requireAuth() -> SiblingsPairResolver
    where
        RelatedModel: Authenticatable {

        SiblingsPairResolver(find: Model.findByIdKeyAndAuthRelated)
    }

    static func byIdKeys() -> SiblingsPairResolver  {
        SiblingsPairResolver(find: Model.findByIdKeys)
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

    static func byIdKeys() -> ModelResolver {
        ModelResolver(find: Model.findByIdKey)
    }
}

