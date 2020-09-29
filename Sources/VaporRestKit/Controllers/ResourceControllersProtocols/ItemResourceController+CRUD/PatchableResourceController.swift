//
//  
//  
//
//  Created by Sergey Kazakov on 26.04.2020.
//

import Vapor
import Fluent

protocol PatchableResourceController: ItemResourceControllerProtocol {
    associatedtype Patch
    func patch(_: Request) throws -> EventLoopFuture<Output>
}

extension PatchableResourceController
    where
    Self: ResourceModelProvider,
    Self.Patch: ResourcePatchModel,
    Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)
        return req.db.tryTransaction { db in

            try self.find(req, database: db)
                .flatMap { patchModel.patch($0, req: req, database: db) }
                .flatMap { $0.update(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

extension PatchableResourceController
    where
    Self: ChildrenResourceModelProvider,
    Patch: ResourcePatchModel,
    Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)
        return req.db.tryTransaction { db in
            try self.findWithRelated(req, database: db)
                .flatMap { patchModel.patch($0.resource, req: req, database: db).and(value: $0.relatedResource) }
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.0,
                                                                        relatedModel: $0.1,
                                                                        req: req,
                                                                        database: db).map { $0.0 } }
                .flatMap { $0.update(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

extension PatchableResourceController
    where
    Self: ParentResourceModelProvider,
    Patch: ResourcePatchModel,
    Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)
        return req.db.tryTransaction { db in
            try self.findWithRelated(req, database: db)
                .flatMap { patchModel.patch($0.resource, req: req, database: db).and(value: $0.relatedResource) }
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.0,
                                                                        relatedModel: $0.1,
                                                                        req: req,
                                                                        database: db).map { $0.0 } }
                .flatMap { $0.update(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

extension PatchableResourceController
    where
    Self: SiblingsResourceModelProvider,
    Patch: ResourcePatchModel,
    Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)
        return req.db.tryTransaction { db in
            try self.findWithRelated(req, database: db)
                .flatMap { patchModel.patch($0.resource, req: req, database: db).and(value: $0.relatedResoure) }
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.0,
                                                                        relatedModel: $0.1,
                                                                        req: req,
                                                                        database: db).map { $0.0 } }
                .flatMap { $0.update(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}
