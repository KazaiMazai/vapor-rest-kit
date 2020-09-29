//
//  
//  
//
//  Created by Sergey Kazakov on 29.04.2020.
//

import Vapor
import Fluent

protocol DeletableResourceController: ItemResourceControllerProtocol {
    func delete(_ req: Request) throws -> EventLoopFuture<Output>

    var deleter: DeleteHandler<Model> { get }
}

extension DeletableResourceController where Self: ResourceModelProvider {
    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        let db = req.db
        return try self.find(req, database: db)
            .flatMap { self.deleter
                .performDelete($0, req: req, database: db)
                .transform(to: $0) }
            .flatMapThrowing { try Output($0, req: req) }
    }
}

extension DeletableResourceController where Self: ChildrenResourceModelProvider {
    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        req.db.tryTransaction { db in
            try self.findWithRelated(req, database: db)
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.resource,
                                                                        relatedModel: $0.relatedResource,
                                                                        req: req,
                                                                        database: db) }
                .flatMap { self.deleter.performDelete($0.0, req: req, database: db).transform(to: $0.0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

extension DeletableResourceController where Self: ParentResourceModelProvider {
    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        req.db.tryTransaction { db in
            try self.findWithRelated(req, database: db)
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.resource,
                                                                        relatedModel: $0.relatedResource,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (resource, related) in
                    try resource.detached(from: related, with: self.inversedChildrenKeyPath)
                    return related.save(on: db).transform(to: resource) }
                .flatMap { $0 }
                .flatMap { self.deleter
                    .performDelete($0, req: req, database: db)
                    .transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

extension DeletableResourceController where Self: SiblingsResourceModelProvider {
    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        req.db.tryTransaction { db in
            try self.findWithRelated(req, database: db)
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.resource,
                                                                        relatedModel: $0.relatedResoure,
                                                                        req: req,
                                                                        database: db) }
                .flatMap { (resource, related) in resource.detached(from: related, with: self.siblingKeyPath, on: db) }
                .flatMap { self.deleter
                    .performDelete($0, req: req, database: db)
                    .transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

public struct DeleteHandler<Model: Fluent.Model> {
    public typealias Handler = (Model, Bool, Request, Database) -> EventLoopFuture<Model>

    fileprivate let deleteHandler: Handler
    fileprivate let useForcedDelete: Bool

    public init(handler: @escaping Handler = Self.defaultDeleteMethod, useForcedDelete: Bool = false) {
        self.deleteHandler = handler
        self.useForcedDelete = useForcedDelete
    }

    public static var defaultDeleter: DeleteHandler<Model> {
        return DeleteHandler(handler: defaultDeleteMethod, useForcedDelete: false)
    }

    public static var defaultDeleteMethod: Handler {
        return { model, forceDelete, _, db in model.delete(force: forceDelete, on: db).transform(to: model) }
    }

    func performDelete(_ model: Model,
                         req: Request,
                         database: Database) -> EventLoopFuture<Model> {

        return deleteHandler(model, useForcedDelete, req, database)
    }
}
