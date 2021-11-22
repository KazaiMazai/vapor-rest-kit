//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent


public extension ResourceController {
    func create<Input, Model>(
        req: Request,
        using: Input.Type) throws -> EventLoopFuture<Output>
    where
        Input: ResourceUpdateModel,
        Output.Model == Model,
        Input.Model == Output.Model {

        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)

        return req.db.tryTransaction { db in
            inputModel
                .update(Output.Model(), req: req, database: db)
                .flatMap { $0.save(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}

public extension RelatedResourceController {
    func create<Input, Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        relationKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        Input: ResourceUpdateModel,
        Model == Output.Model,
        Input.Model == Output.Model {

        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        return req.db.tryTransaction { db in

            try resolver
                .find(req, db)
                .and(inputModel.update(Output.Model(), req: req, database: db))
                .flatMap { (related, model) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMapThrowing { (model, related) in try model.attached(to: related, with: relationKeyPath) }
                .flatMap { model in model.save(on: db).transform(to: model) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    func create<Input, Model, RelatedModel>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        relationKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Input: ResourceUpdateModel,
        Model == Output.Model,
        Input.Model == Output.Model {

        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        let keyPath = relationKeyPath
        return req.db.tryTransaction { db in

            try resolver
                .find(req, db)
                .and(inputModel.update(Output.Model(), req: req, database: db))
                .flatMap { (related, model) in middleware.handle(model,
                                                                        relatedModel: related,
                                                                        req: req,
                                                                        database: db) }
                .flatMap { (model, related) in  model.save(on: db).transform(to: (model, related)) }
                .flatMapThrowing { (model, related) in (try model.attached(to: related, with: keyPath), related) }
                .flatMap { (model, related) in [related.save(on: db), model.save(on: db)]
                    .flatten(on: db.context.eventLoop)
                    .transform(to: model) }
                .flatMapThrowing { try Output($0, req: req)}
        }
    }

    func create<Input, Model, RelatedModel, Through>(
        resolver: Resolver<RelatedModel> = .byIdKeys,
        req: Request,
        using: Input.Type,
        willAttach middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
        relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where
        Input: ResourceUpdateModel,
        Model == Output.Model,
        Input.Model == Output.Model,
        Through: Fluent.Model {

        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        return req.db.tryTransaction { db in

            try resolver
                .find(req, db)
                .and(inputModel.update(Output.Model(), req: req, database: db))
                .flatMap { (related, model) in middleware.handle(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMap { (model, related) in model.save(on: db).transform(to: (model, related)) }
                .flatMap { (model, related) in model.attached(to: related, with: relationKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}
