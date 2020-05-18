//
//  
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

extension CreatableResourceController where Self: ResourceModelProvider,
                                            Input: ResourceUpdateModel,
                                            Model == Input.Model  {

    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        let db = req.db
        return inputModel.update(Model(), req: req, database: db)
            .flatMap { $0.save(on: req.db).transform(to: Output($0, req: req)) }
    }
}

extension CreatableResourceController where Self: ChildrenResourceModelProvider,
    Input: ResourceUpdateModel,
    Model == Input.Model {

    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        let db = req.db
        return try self.findRelated(req)
            .and(inputModel.update(Model(), req: req, database: db))
            .flatMap { self.relatedResourceMiddleware.willSave($0.1, relatedModel: $0.0, req: req, database: db) }
            .flatMapThrowing { try $0.0.attached(to: $0.1, with: self.childrenKeyPath) }
            .flatMap { $0.save(on: req.db).transform(to: Output($0, req: req)) }
    }
}

extension CreatableResourceController where Self: ParentResourceModelProvider,
    Input: ResourceUpdateModel,
    Model == Input.Model  {

    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        let keyPath = inversedChildrenKeyPath
        let db = req.db

        return try findRelated(req)
            .and(inputModel.update(Model(), req: req, database: db))
            .flatMap { self.relatedResourceMiddleware.willSave($0.1, relatedModel: $0.0, req: req, database: db) }
            .flatMap { (model, related) in  model.save(on: db).transform(to: (model, related)) }
            .flatMapThrowing { (model, related) in (try model.attached(to: related, with: keyPath), related) }
            .flatMap { (model, related) in [related.save(on: db), model.save(on: db)]
                .flatten(on: req.eventLoop)
                .transform(to: Output(model, req: req)) }
    }
}

extension CreatableResourceController where Self: SiblingsResourceModelProvider,
    Input: ResourceUpdateModel,
    Model == Input.Model {

    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        let db = req.db

        return try self.findRelated(req)
            .and(inputModel.update(Model(), req: req, database: db))
            .flatMap { self.relatedResourceMiddleware.willSave($0.1, relatedModel: $0.0, req: req, database: db) }
            .flatMap { (model, related) in model.save(on: db).transform(to: (model, related)) }
            .flatMap { (model, related) in model.attached(to: related, with: self.siblingKeyPath, on: db) }
            .map { Output($0, req: req) }
    }
}





