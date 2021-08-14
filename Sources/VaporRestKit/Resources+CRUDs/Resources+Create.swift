//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent


extension ResourceController {
    static func create<Input, Output>(req: Request, using: Input.Type) throws -> EventLoopFuture<Output> where
        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
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

extension ResourceController {
     static func createRelated<Input, Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
        where

        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Model == Output.Model,
        Input.Model == Output.Model {

        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        return req.db.tryTransaction { db in

            try resolver
                .find(req, db)
                .and(inputModel.update(Output.Model(), req: req, database: db))
                .flatMap { (related, model) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMapThrowing { try $0.0.attached(to: $0.1, with: childrenKeyPath) }
                .flatMap { $0.save(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    static func createRelated<Input, Output, RelatedModel>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
        where

        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Model == Output.Model,
        Input.Model == Output.Model {


        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        let keyPath = childrenKeyPath
        return req.db.tryTransaction { db in

            try resolver
                .find(req, db)
                .and(inputModel.update(Output.Model(), req: req, database: db))
                .flatMap { (related, model) in relatedResourceMiddleware.handleRelated(model,
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

    static func createRelated<Input, Output, RelatedModel, Through>(
        resolver: ModelResolver<RelatedModel>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
        where

        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Model == Output.Model,
        Input.Model == Output.Model,
        Through: Fluent.Model {

        try Input.validate(content: req)
        let inputModel = try req.content.decode(Input.self)
        return req.db.tryTransaction { db in

            try resolver
                .find(req, db)
                .and(inputModel.update(Output.Model(), req: req, database: db))
                .flatMap { (related, model) in relatedResourceMiddleware.handleRelated(model,
                                                                                       relatedModel: related,
                                                                                       req: req,
                                                                                       database: db) }
                .flatMap { (model, related) in model.save(on: db).transform(to: (model, related)) }
                .flatMap { (model, related) in model.attached(to: related, with: siblingKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }
}
