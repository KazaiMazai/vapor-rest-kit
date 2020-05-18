//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

protocol CreatableRelationController: ItemResourceControllerProtocol {
    associatedtype RelatedModel: Fluent.Model

    func create(_ req: Request) throws -> EventLoopFuture<Output>
}

extension CreatableRelationController where Self: ChildrenResourceRelationProvider {
    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        return req.db.tryTransaction { db in

            try self.findWithRelated(req, database: db)
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.resource,
                                                                        relatedModel: $0.relatedResource,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (resource, related) in
                    try resource.attached(to: related, with: self.childrenKeyPath) }
                .flatMap { $0.save(on: db).transform(to: $0) }
                .map { Output($0, req: req) }
        }
    }
}

extension CreatableRelationController where Self: ParentResourceRelationProvider {
    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        return req.db.tryTransaction { db in

            try self.findWithRelated(req, database: db)
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.resource,
                                                                        relatedModel: $0.relatedResource,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (resource, related) in
                    try resource.attached(to: related, with: self.inversedChildrenKeyPath)
                    return related.save(on: db).transform(to: resource) }
                .flatMap { $0 }
                .map { Output($0, req: req) }
        }
    }
}

extension CreatableRelationController where Self: SiblingsResourceRelationProvider {
    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        return req.db.tryTransaction { db in

            try self.findWithRelated(req, database: db)
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.resource,
                                                                        relatedModel: $0.relatedResoure,
                                                                        req: req,
                                                                        database: db) }
                .flatMap { (resource, related) in
                    resource.attached(to: related, with: self.siblingKeyPath, on: db) }
                .map { Output($0, req: req)}
        }
    }
}

