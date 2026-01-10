//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.08.2021.
//

import Vapor
import Fluent

public struct ChildResolver<Model, RelatedModel>
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

public extension ChildResolver {
    static func requireAuth() -> ChildResolver where RelatedModel: Authenticatable {
        ChildResolver(find: Model.findByIdKeyAndAuthRelated)
    }

    static var byIdKeys: ChildResolver {
        ChildResolver(find: Model.findByIdKeys)
    }
    
    static func requireAuth(
        didResolve middleware: ControllerMiddleware<Model, RelatedModel>
    ) -> ChildResolver
    where
    RelatedModel: Authenticatable {
        
        ChildResolver { req, db, keyPath, queryModifier in
            try Model.findByIdKeyAndAuthRelated(
                req,
                database: db,
                childrenKeyPath: keyPath,
                queryModifier: queryModifier
            )
            .flatMap { model, relatedModel in
                middleware.handle(
                    model,
                    relatedModel: relatedModel,
                    req: req,
                    database: db
                )
            }
        }
    }

    static func byIdKeys(
        didResolve middleware: ControllerMiddleware<Model, RelatedModel>
    ) -> ChildResolver {
        ChildResolver { req, db, keyPath, queryModifier in
            try Model.findByIdKeys(
                req,
                database: db,
                childrenKeyPath: keyPath,
                queryModifier: queryModifier
            )
            .flatMap { model, relatedModel in
                middleware.handle(
                    model,
                    relatedModel: relatedModel,
                    req: req,
                    database: db
                )
            }
        }
    }
}

public struct ParentResolver<Model, RelatedModel>
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

public extension ParentResolver {
    static func requireAuth() -> ParentResolver where RelatedModel: Authenticatable {
        ParentResolver(find: Model.findByIdKeyAndAuthRelated)
    }

    static var byIdKeys: ParentResolver {
        ParentResolver(find: Model.findByIdKeys)
    }
    
    static func requireAuth(
        didResolve middleware: ControllerMiddleware<Model, RelatedModel>
    ) -> ParentResolver
    where
    RelatedModel: Authenticatable {
        
        ParentResolver { req, db, keyPath, queryModifier in
            try Model.findByIdKeyAndAuthRelated(
                req,
                database: db,
                childrenKeyPath: keyPath,
                queryModifier: queryModifier
            )
            .flatMap { model, relatedModel in
                middleware.handle(
                    model,
                    relatedModel: relatedModel,
                    req: req,
                    database: db
                )
            }
        }
    }

    static func byIdKeys(
        didResolve middleware: ControllerMiddleware<Model, RelatedModel>
    ) -> ParentResolver {
        
        ParentResolver { req, db, keyPath, queryModifier in
            try Model.findByIdKeys(
                req,
                database: db,
                childrenKeyPath: keyPath,
                queryModifier: queryModifier
            )
            .flatMap { model, relatedModel in
                middleware.handle(
                    model,
                    relatedModel: relatedModel,
                    req: req,
                    database: db
                )
            }
        }
    }
}


public struct SiblingsResolver<Model, RelatedModel, Through>
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

public extension SiblingsResolver {
    static func requireAuth() -> SiblingsResolver where RelatedModel: Authenticatable {

        SiblingsResolver(find: Model.findByIdKeyAndAuthRelated)
    }

    static var byIdKeys: SiblingsResolver {
        SiblingsResolver(find: Model.findByIdKeys)
    }
    
    static func requireAuth(
        didResolve middleware: ControllerMiddleware<Model, RelatedModel>
    ) -> SiblingsResolver
    where
    RelatedModel: Authenticatable {
        
        SiblingsResolver { req, db, keyPath, queryModifier in
            try Model.findByIdKeyAndAuthRelated(
                req,
                database: db,
                siblingKeyPath: keyPath,
                queryModifier: queryModifier
            )
            .flatMap { model, relatedModel in
                middleware.handle(
                    model,
                    relatedModel: relatedModel,
                    req: req,
                    database: db
                )
            }
        }
    }

    static func byIdKeys(
        didResolve middleware: ControllerMiddleware<Model, RelatedModel>
    ) -> SiblingsResolver {
        
        SiblingsResolver { req, db, keyPath, queryModifier in
            try Model.findByIdKeys(
                req,
                database: db,
                siblingKeyPath: keyPath,
                queryModifier: queryModifier
            )
            .flatMap { model, relatedModel in
                middleware.handle(
                    model,
                    relatedModel: relatedModel,
                    req: req,
                    database: db
                )
            }
        }
    }
}

public struct Resolver<Model> where Model: Fluent.Model,
                             Model.IDValue: LosslessStringConvertible {

    let find: (_ req: Request,
               _ db: Database,
               _ queryModifier: QueryModifier<Model>) throws -> EventLoopFuture<Model>
    
    
    func find(_ req: Request,
              _ db: Database) throws -> EventLoopFuture<Model> {
        try find(req, db, .empty)
    }
}

public extension Resolver {
    static func requireAuth() -> Resolver where Model: Authenticatable {
        Resolver(find: Model.requireAuth)
    }

    static var byIdKeys: Resolver {
        Resolver(find: Model.findByIdKey)
    }
    
    static func requireAuth(
        didResolve middleware: ControllerMiddleware<Model, Model>
    ) -> Resolver where Model: Authenticatable {
        
        Resolver { req, db, queryModifier in
            try Model.requireAuth(
                req,
                database: db,
                queryModifier: queryModifier
            )
            .flatMap { model in
                middleware.handle(
                    model,
                    req: req,
                    database: db
                )
            }
        }
    }

    static func byIdKeys(
        didResolve middleware: ControllerMiddleware<Model, Model>
    ) -> Resolver {
        
        Resolver { req, db, queryModifier in
            try Model.findByIdKey(
                req,
                database: db,
                queryModifier: queryModifier
            )
            .flatMap { model in
                middleware.handle(
                    model,
                    req: req,
                    database: db
                )
            }
        }
    }
    
}

