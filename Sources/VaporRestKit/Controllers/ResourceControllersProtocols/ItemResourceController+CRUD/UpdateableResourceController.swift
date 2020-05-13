//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 26.04.2020.
//

import Vapor
import Fluent

protocol UpdateableResourceController: ItemResourceControllerProtocol {
    associatedtype Input
 
    func update(_: Request) throws -> EventLoopFuture<Output>
}

extension UpdateableResourceController where Self: ResourceModelProviding,
                                            Input: ResourceUpdateModel,
                                            Model == Input.Model  {

    func update(_ req: Request) throws -> EventLoopFuture<Output> {
        let request = try req.content.decode(Input.self)
        return try self.find(req)
                       .flatMapThrowing { return request.update($0) }
                       .flatMap { model in return model.update(on: req.db)
                                                       .map { Output(model) }}
    }
}

extension UpdateableResourceController where Self: ChildrenResourceModelProviding,
                                            Input: ResourceUpdateModel,
                                            Model == Input.Model {

    func update(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        let keyPath = childrenKeyPath

        return try self.findWithRelated(req)
                       .flatMapThrowing { return try inputModel.update($0.resource)
                                                               .attached(to: $0.relatedResource, with: keyPath) }
                       .flatMap { model in return model.save(on: req.db)
                                                       .map { Output(model) }}
    }
}

extension UpdateableResourceController where Self: ParentResourceModelProviding,
                                            Input: ResourceUpdateModel,
                                            Model == Input.Model  {

    func update(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        let keyPath = inversedChildrenKeyPath

        return try self.findWithRelated(req)
                       .flatMapThrowing { (resource: inputModel.update($0.resource),
                                            relatedResource: $0.relatedResource) }
                       .flatMapThrowing { (resource, relatedResource) in
                                                (resource: try resource.attached(to: relatedResource, with: keyPath),
                                                relatedResource: relatedResource) }
                       .map { (resource, relatedResource) in
                            [resource.save(on: req.db), relatedResource.save(on: req.db)].flatten(on: req.eventLoop)
                                                                             .map { _ in resource }}
                       .flatMap { $0 }
                       .map { Output($0) }
    }
}


extension UpdateableResourceController where Self: SiblingsResourceModelProviding,
                                            Input: ResourceUpdateModel,
                                            Model == Input.Model {

    func update(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)

        return try self.findWithRelated(req)
                       .flatMap { return inputModel.update($0.resource)
                                                    .attached(to: $0.relatedResoure,
                                                            with: self.siblingKeyPath,
                                                            on: req.db) }
                       .map { Output($0) }
    }
}
