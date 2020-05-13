//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 29.04.2020.
//

import Vapor
import Fluent

protocol CreatableResourceController: ItemResourceControllerProtocol {
    associatedtype Input

    func create(_ req: Request) throws -> EventLoopFuture<Output>
}

extension CreatableResourceController where Self: ResourceModelProviding,
                                            Input: ResourceUpdateModel,
                                            Model == Input.Model  {

    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        let model = inputModel.update(Model())

        return model.save(on: req.db)
                    .map { _ in Output(model) }
    }
}

extension CreatableResourceController where Self: ChildrenResourceModelProviding,
                                            Input: ResourceUpdateModel,
                                            Model == Input.Model {

    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)

        return try self.findRelated(req)
                       .flatMapThrowing { return try inputModel.update(Model())
                                                               .attached(to: $0, with: self.childrenKeyPath) }
                       .flatMap { resource in return resource.save(on: req.db)
                                                             .map { _ in Output(resource) } }
    }
}

extension CreatableResourceController where Self: ParentResourceModelProviding,
                                            Input: ResourceUpdateModel,
                                            Model == Input.Model  {

      func create(_ req: Request) throws -> EventLoopFuture<Output> {
            try Input.validate(req)
            let inputModel = try req.content.decode(Input.self)
            let keyPath = inversedChildrenKeyPath

            let resource = inputModel.update(Model())
            return resource.save(on: req.db)
                            .transform(to: resource)
                            .flatMapThrowing { resource in
                                return try self.findRelated(req)
                                               .map { (resource: resource, relatedResource: $0) }}
                            .flatMap { $0 }
                            .flatMapThrowing { (resource, relatedResource) in
                                (resource: try resource.attached(to: relatedResource, with: keyPath),
                                relatedResource: relatedResource) }
                            .map { (resource, relatedResource) in
                                [resource.save(on: req.db), relatedResource.save(on: req.db)]
                                                                           .flatten(on: req.eventLoop)
                                                                           .map { _ in resource } }
                            .flatMap { $0 }
                            .map { Output($0) }
    }
}

extension CreatableResourceController where Self: SiblingsResourceModelProviding,
                                            Input: ResourceUpdateModel,
                                            Model == Input.Model {

    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)

        return try self.findRelated(req)
                       .flatMapThrowing { relatedResource in
                            return (inputModel.update(Model()), relatedResource)  }
                       .flatMap { (resource, relatedResource) in
                            return resource.save(on: req.db)
                                           .transform(to: (resource, relatedResource)) }
                        .flatMap { (resource, relatedResource) in
                            return resource.attached(to: relatedResource, with: self.siblingKeyPath, on: req.db) }
                        .map { Output($0) }
    }
}





