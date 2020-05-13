//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 02.05.2020.
//

import Fluent
import Vapor

protocol SiblingsResourceModelProviding: ResourceModelProviding
    where Model.IDValue: LosslessStringConvertible,
        RelatedModel: Fluent.Model,
        Through: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

    associatedtype Model
    associatedtype RelatedModel
    associatedtype Through

    var rootIdComponentKey: String { get }
    var rootIdPathComponent: PathComponent { get }

    var relationNamePath: String { get }
    var siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through> { get }

    func findWithRelated(_ req: Request) throws -> EventLoopFuture<(resource: Model, relatedResoure: RelatedModel)>

    func findRelated(_ req: Request) throws -> EventLoopFuture<RelatedModel>

}

extension SiblingsResourceModelProviding {
    var idKey: String { Model.schema }
    var idPathComponent: PathComponent { return PathComponent(stringLiteral: ":\(self.idKey)") }
    var rootIdComponentKey: String { RelatedModel.schema }
    var rootIdPathComponent: PathComponent { return PathComponent(stringLiteral: ":\(self.rootIdComponentKey)") }
    var relationPathComponent: PathComponent { return PathComponent(stringLiteral: "\(self.relationNamePath)") }


    func resourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [rootIdPathComponent, relationPathComponent, endpointPath]
    }

    func idResourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [rootIdPathComponent, relationPathComponent, endpointPath, idPathComponent]
    }

    func find(_ req: Request) throws -> EventLoopFuture<Model> {
        return try findOn(self.siblingKeyPath, req: req)
    }

    func findWithRelated(_ req: Request) throws -> EventLoopFuture<(resource: Model, relatedResoure: RelatedModel)> {
        return try findWithRelatedOn(self.siblingKeyPath, req: req)
    }
}

//MARK:- Can be overriden

extension SiblingsResourceModelProviding {
    func findRelated(_ req: Request) throws -> EventLoopFuture<RelatedModel> {
      return try RelatedModel.query(on: req.db)
                            .findBy(rootIdComponentKey, from: req)
    }
}

//MARK:- Private

extension SiblingsResourceModelProviding {
    fileprivate func findOn(_ siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>,
                            req: Request) throws -> EventLoopFuture<Model> {
        return try findWithRelatedOn(siblingKeyPath, req: req).map { $0.resource }
    }

    fileprivate func findWithRelatedOn(_ siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>,
                                      req: Request) throws -> EventLoopFuture<(resource: Model, relatedResoure: RelatedModel)> {

        return try findRelated(req).flatMapThrowing { relatedResoure in
                                     return try relatedResoure.queryRelated(keyPath: siblingKeyPath, on: req.db)
                                                    .with(self.eagerLoadHandler, for: req)
                                                    .sort(self.sortingHandler, for: req)
                                                    .filter(self.filteringHandler, for: req)
                                                    .findBy(self.idKey, from: req)
                                                    .map { ($0, relatedResoure) }}
                                   .flatMap { $0 }
    }
}

