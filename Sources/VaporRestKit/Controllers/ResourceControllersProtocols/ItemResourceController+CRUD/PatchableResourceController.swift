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

extension PatchableResourceController where Self: ResourceModelProvider,
    Self.Patch: ResourcePatchModel,
    Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)
        let db = req.db
        return try self.find(req)
            .flatMapThrowing { try patchModel.patch($0) }
            .flatMap { self.resourceMiddleware.willSave($0, req: req, database: db) }
            .flatMap { $0.update(on: db).transform(to: Output($0, req: req)) }
    }
}

extension PatchableResourceController where Self: ChildrenResourceModelProvider,
    Patch: ResourcePatchModel,
    Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)
        let db = req.db
        return try self.findWithRelated(req)
            .flatMapThrowing { (try patchModel.patch($0.resource), $0.relatedResource)  }
            .flatMap { self.relatedResourceMiddleware.willSave($0.0, relatedModel: $0.1, req: req, database: db).map { $0.0 } }
            .flatMap { $0.update(on: db).transform(to: Output($0, req: req)) }
    }
}

extension PatchableResourceController where Self: ParentResourceModelProvider,
    Patch: ResourcePatchModel,
Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)
        let db = req.db
        return try self.findWithRelated(req)
            .flatMapThrowing { (try patchModel.patch($0.resource), $0.relatedResource)  }
            .flatMap { self.relatedResourceMiddleware.willSave($0.0, relatedModel: $0.1, req: req, database: db).map { $0.0 } }
            .flatMap { $0.update(on: db).transform(to: Output($0, req: req)) }
    }
}

extension PatchableResourceController where Self: SiblingsResourceModelProvider,
    Patch: ResourcePatchModel,
    Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)
        let db = req.db
        return try self.findWithRelated(req)
            .flatMapThrowing { (try patchModel.patch($0.resource), $0.relatedResoure) }
            .flatMap { self.relatedResourceMiddleware.willSave($0.0, relatedModel: $0.1, req: req, database: db).map { $0.0 } }
            .flatMap { $0.update(on: db).transform(to: Output($0, req: req)) }
    }
}
