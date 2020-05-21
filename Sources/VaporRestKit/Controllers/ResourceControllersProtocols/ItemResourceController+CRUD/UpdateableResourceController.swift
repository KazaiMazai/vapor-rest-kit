//
//  
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

extension UpdateableResourceController
    where
    Self: ResourceModelProvider,
    Input: ResourceUpdateModel,
    Model == Input.Model  {

    func update(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        return req.db.tryTransaction { db in

            try self.find(req, database: db)
                .flatMap { inputModel.update($0, req: req, database: db) }
                .flatMap { model in return model.save(on: db)
                    .map { Output(model, req: req) }}
        }
    }
}

extension UpdateableResourceController
    where
    Self: ChildrenResourceModelProvider,
    Input: ResourceUpdateModel,
    Model == Input.Model {

    func update(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        let keyPath = childrenKeyPath
        return req.db.tryTransaction { db in

            try self.findWithRelated(req, database: db)
                .flatMap { inputModel.update($0.resource , req: req ,database: db).and(value: $0.relatedResource) }
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.0, relatedModel: $0.1, req: req, database: db) }
                .flatMapThrowing { try $0.0.attached(to: $0.1, with: keyPath) }
                .flatMap { $0.save(on: db).transform(to: $0) }
                .map { Output($0, req: req) }
        }
    }
}

extension UpdateableResourceController
    where
    Self: ParentResourceModelProvider,
    Input: ResourceUpdateModel,
    Model == Input.Model  {

    func update(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        let keyPath = inversedChildrenKeyPath
        return req.db.tryTransaction { db in

            try self.findWithRelated(req, database: db)
                .flatMap { inputModel.update($0.resource, req: req, database: db).and(value: $0.relatedResource) }
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.0, relatedModel: $0.1, req: req, database: db) }
                .flatMapThrowing { (try $0.0.attached(to: $0.1, with: keyPath), $0.1) }
                .flatMap {
                    [$0.0.save(on: db),$0.1.save(on: db)]
                        .flatten(on: db.context.eventLoop)
                        .transform(to: $0.0) }
                .map { Output($0, req: req) }
        }
    }
}


extension UpdateableResourceController
    where
    Self: SiblingsResourceModelProvider,
    Input: ResourceUpdateModel,
    Model == Input.Model {

    func update(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        return req.db.tryTransaction { db in

            try self.findWithRelated(req, database: db)
                .flatMap { inputModel.update($0.resource, req: req, database: db).and(value: $0.relatedResoure) }
                .flatMap { self.relatedResourceMiddleware.handleRelated($0.0, relatedModel: $0.1, req: req, database: db) }
                .flatMap { $0.0.attached(to: $0.1, with: self.siblingKeyPath, on: db) }
                .map { Output($0, req: req) }
        }
    }
}
