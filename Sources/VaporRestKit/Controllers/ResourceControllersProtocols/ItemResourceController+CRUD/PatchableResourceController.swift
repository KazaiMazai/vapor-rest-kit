//
//  File.swift
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
        return try self.find(req)
                       .flatMapThrowing { return patchModel.patch($0) }
                       .flatMap { model in return model.update(on: req.db)
                                                       .map { Output(model) }}
    }
}

extension PatchableResourceController where Self: ChildrenResourceModelProvider,
                                            Patch: ResourcePatchModel,
                                            Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)
        
        return try self.findWithRelated(req)
                       .flatMapThrowing { return patchModel.patch($0.resource) }
                       .flatMap { model in return model.update(on: req.db)
                                                       .map { Output(model) }}
    }
}

extension PatchableResourceController where Self: ParentResourceModelProvider,
                                            Patch: ResourcePatchModel,
                                            Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)

        return try self.findWithRelated(req)
                       .flatMapThrowing { return patchModel.patch($0.resource) }
                       .flatMap { model in return model.update(on: req.db)
                                                       .map { Output(model) }}
    }
}

extension PatchableResourceController where Self: SiblingsResourceModelProvider,
                                            Patch: ResourcePatchModel,
                                            Model == Patch.Model {

    func patch(_ req: Request) throws -> EventLoopFuture<Output> {
        try Patch.validate(req)
        let patchModel = try req.content.decode(Patch.self)

        return try self.findWithRelated(req)
                       .flatMapThrowing { return patchModel.patch($0.resource) }
                       .flatMap { model in return model.update(on: req.db)
                                                       .map { Output(model) }}
    }
}
