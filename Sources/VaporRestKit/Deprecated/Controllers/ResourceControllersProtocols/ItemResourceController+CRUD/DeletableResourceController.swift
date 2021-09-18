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

    var deleter: Deleter<Model> { get }
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
                .flatMap { self.relatedResourceMiddleware.handle($0.resource,
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
                .flatMap { self.relatedResourceMiddleware.handle($0.resource,
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
                .flatMap { self.relatedResourceMiddleware.handle($0.resource,
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
