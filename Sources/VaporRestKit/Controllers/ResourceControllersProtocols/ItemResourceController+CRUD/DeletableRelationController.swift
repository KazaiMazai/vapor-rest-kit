//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

protocol DeletableRelationController: ItemResourceControllerProtocol {
    associatedtype RelatedModel: Fluent.Model

    func delete(_ req: Request) throws -> EventLoopFuture<Output>
}

extension DeletableRelationController
where Self: ChildrenResourceRelationProvider {

    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        return req.db.tryTransaction { db in

            try self.findWithRelated(req, database: db)
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.resource,
                                                                        relatedModel: $0.relatedResource,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { try $0.0.detached(from: $0.1, with: self.childrenKeyPath) }
                .flatMap { resource in return resource.save(on: db)
                                                      .transform(to: Output(resource, req: req)) }
        }
    }
}

extension DeletableRelationController where Self: ParentResourceRelationProvider {
    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        return req.db.tryTransaction { db in

            try self.findWithRelated(req, database: db)
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.resource,
                                                                        relatedModel: $0.relatedResource,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (resource, related) in
                    try resource.detached(from: related, with: self.inversedChildrenKeyPath)
                    return related.save(on: db).transform(to: resource) }
                .flatMap { $0 }
                .map { Output($0, req: req) }
        }
    }
}

extension DeletableRelationController where Self: SiblingsResourceRelationProvider {
    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        return req.db.tryTransaction { db in

            try self.findWithRelated(req, database: db)
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.resource,
                                                                        relatedModel: $0.relatedResoure,
                                                                        req: req,
                                                                        database: db) }
                .flatMap {(resource, related) in resource.detached(from: related, with: self.siblingKeyPath, on: db) }
                .map { Output($0, req: req)}
        }
    }
}
