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
            .flatMap { patchModel.patch($0, req: req, database: db) }
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
            .flatMap { patchModel.patch($0.resource, req: req, database: db) }
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
            .flatMap { patchModel.patch($0.resource, req: req, database: db) }
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
            .flatMap { patchModel.patch($0.resource, req: req, database: db) }
            .flatMap { $0.update(on: db).transform(to: Output($0, req: req)) }
    }
}
