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
        return inputModel
            .update(Model(), req: req, database: db)
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
            .flatMapThrowing { try $0.1.attached(to: $0.0, with: self.childrenKeyPath) }
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
            .flatMap { (related, model) in  model.save(on: db).transform(to: (related, model)) }
            .flatMapThrowing { (related, model) in (related, try model.attached(to: related, with: keyPath)) }
            .flatMap { (related, model) in [related.save(on: db), model.save(on: db)]
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
            .and(inputModel.update(Model(),req: req, database: db))
            .flatMap { (related, model) in model.save(on: db).transform(to: (related, model)) }
            .flatMap { (related, model) in model.attached(to: related, with: self.siblingKeyPath, on: db) }
            .map { Output($0, req: req) }
    }
}





