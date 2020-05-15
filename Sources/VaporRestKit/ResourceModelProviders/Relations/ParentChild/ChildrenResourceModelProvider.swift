//
//  
//  
//
//  Created by Sergey Kazakov on 27.04.2020.
//

import Fluent
import Vapor

protocol ChildrenResourceModelProvider: ResourceModelProvider
    where Model.IDValue: LosslessStringConvertible,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

    associatedtype Model
    associatedtype RelatedModel

    var rootIdComponentKey: String { get }
    var rootIdPathComponent: PathComponent { get }

    var relationNamePath: String { get }
    var childrenKeyPath: ChildrenKeyPath<RelatedModel, Model> { get }

    func findWithRelated(_ req: Request) throws -> EventLoopFuture<(resource: Model, relatedResource: RelatedModel)>

    func findRelated(_ req: Request) throws -> EventLoopFuture<RelatedModel>

}

extension ChildrenResourceModelProvider {
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
        return try findOn(self.childrenKeyPath, req: req)
    }

    func findWithRelated(_ req: Request) throws -> EventLoopFuture<(resource: Model, relatedResource: RelatedModel)> {
        return try findWithRelatedOn(self.childrenKeyPath, req: req)
    }
}

//MARK:- Can be overriden

extension ChildrenResourceModelProvider {
    func findRelated(_ req: Request) throws -> EventLoopFuture<RelatedModel> {
      return try RelatedModel.query(on: req.db)
                            .findBy(rootIdComponentKey, from: req)
    }
}

//MARK:- Private

extension ChildrenResourceModelProvider {
    fileprivate func findOn(_ childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
                            req: Request) throws -> EventLoopFuture<Model> {
        return try findWithRelatedOn(childrenKeyPath, req: req).map { $0.resource }
    }

    fileprivate func findWithRelatedOn(_ childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
                                      req: Request) throws -> EventLoopFuture<(resource: Model, relatedResource: RelatedModel)> {

        return try findRelated(req).flatMapThrowing { relatedResource in
                                          return try relatedResource.query(keyPath: childrenKeyPath, on: req.db)
                                                                    .with(self.eagerLoadHandler, for: req)
                                                                    .sort(self.sortingHandler, for: req)
                                                                    .filter(self.filteringHandler, for: req)
                                                                    .findBy(self.idKey, from: req)
                                                                    .map { ($0, relatedResource) }}
                                   .flatMap { $0 }
    }
}



