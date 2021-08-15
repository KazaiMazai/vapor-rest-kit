//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.08.2021.
//

import Vapor
import Fluent

struct ChildPairResolver<Model, RelatedModel>
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

extension ChildPairResolver {
    static func asAuth() -> ChildPairResolver where RelatedModel: Authenticatable {
        ChildPairResolver(find: Model.findWithAuthRelatedOn)
    }

    static func asRequestPath() -> ChildPairResolver {
        ChildPairResolver(find: Model.findWithRelatedOn)
    }
}

struct ParentPairResolver<Model, RelatedModel>
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

extension ParentPairResolver {
    static func asAuth() -> ParentPairResolver where RelatedModel: Authenticatable {
        ParentPairResolver(find: Model.findWithAuthRelatedOn)
    }

    static func asRequestPath() -> ParentPairResolver {
        ParentPairResolver(find: Model.findWithRelatedOn)
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
    static func asAuth() -> SiblingsPairResolver
    where
        RelatedModel: Authenticatable {

        SiblingsPairResolver(find: Model.findWithAuthRelatedOn)
    }

    static func asRequestPath() -> SiblingsPairResolver  {
        SiblingsPairResolver(find: Model.findWithRelatedOn)
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
    static func asAuth() -> ModelResolver where Model: Authenticatable {
        ModelResolver(find: Model.findAsAuth)
    }

    static func asRequestPath() -> ModelResolver {
        ModelResolver(find: Model.findByIdKey)
    }
}

