//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {

    static func createRelation<Output, RelatedModel>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Self>) throws -> EventLoopFuture<Output>
        where

        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Output.Model: ResourceOutputModel,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {


        return req.db.tryTransaction { db in

            try RelatedModel.findByIdKey(req, database: db)
                .and(Self.findByIdKey(req, database: db))
                .flatMap { relatedResourceMiddleware.handleRelated($0.1,
                                                                   relatedModel: $0.0,
                                                                   req: req,
                                                                   database: db) }
                .flatMapThrowing { (resource, related) in
                    try resource.attached(to: related, with: childrenKeyPath) }
                .flatMap { $0.save(on: db).transform(to: $0) }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    static func createRelation<Output, RelatedModel>(
        req: Request,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        childrenKeyPath: ChildrenKeyPath<Self, RelatedModel>) throws -> EventLoopFuture<Output>
        where


        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Output.Model: ResourceOutputModel,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {


        return req.db.tryTransaction { db in

            try RelatedModel.findByIdKey(req, database: db)
                .and(Self.findByIdKey(req, database: db))
                .flatMap { relatedResourceMiddleware.handleRelated($0.1,
                                                                   relatedModel: $0.0,
                                                                   req: req,
                                                                   database: db) }
                .flatMapThrowing { (resource, related) in
                    try resource.attached(to: related, with: childrenKeyPath)
                    return related.save(on: db).transform(to: resource) }
                .flatMap { $0 }
                .flatMapThrowing { try Output($0, req: req) }
        }
    }

    static func createRelation<Input, Output, RelatedModel, Through>(
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Self, RelatedModel> = .defaultMiddleware,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Self, Through>) throws -> EventLoopFuture<Output>
        where

        Input: ResourceUpdateModel,
        Output: ResourceOutputModel,
        Output.Model: Fluent.Model,
        Through: Fluent.Model,
        Output.Model.IDValue: LosslessStringConvertible,
        Self == Output.Model,
        Input.Model == Output.Model,
        Output.Model: ResourceOutputModel,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        return req.db.tryTransaction { db in

            try RelatedModel.findByIdKey(req, database: db)
                .and(Self.findByIdKey(req, database: db))
                .flatMap { relatedResourceMiddleware.handleRelated($0.1,
                                                                   relatedModel: $0.0,
                                                                   req: req,
                                                                   database: db) }
                .flatMap { (resource, related) in
                    resource.attached(to: related, with: siblingKeyPath, on: db) }
                .flatMapThrowing { try Output($0, req: req)}
        }
    }
}

