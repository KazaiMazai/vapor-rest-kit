//
//  
//  
//
//  Created by Sergey Kazakov on 29.04.2020.
//

import Fluent
import Vapor

protocol ParentResourceModelProvider: ResourceModelProvider
    where Model.IDValue: LosslessStringConvertible,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

    associatedtype Model
    associatedtype RelatedModel

    var rootIdComponentKey: String { get }
    var rootIdPathComponent: PathComponent { get }

    var relatedResourceMiddleware: RelatedControllerMiddleware<Model, RelatedModel> { get }
    var relationNamePath: String { get }
    var inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel> { get }

    func findWithRelated(_ req: Request) throws -> EventLoopFuture<(relatedResource: RelatedModel, resource: Model)>

    func findRelated(_ req: Request) throws -> EventLoopFuture<RelatedModel>
}

extension ParentResourceModelProvider {
    var idKey: String { Model.schema }
    var idPathComponent: PathComponent { return PathComponent(stringLiteral: ":\(self.idKey)") }

    var rootIdComponentKey: String { RelatedModel.schema }
    var rootIdPathComponent: PathComponent { return PathComponent(stringLiteral: ":\(self.rootIdComponentKey)") }
    var relationPathComponent: PathComponent { return PathComponent(stringLiteral: "\(self.relationNamePath)") }

    var resourceMiddleware: ControllerMiddleware<Model> { .defaultMiddleware }

    func resourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [rootIdPathComponent, relationPathComponent, endpointPath]
    }

    func idResourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [rootIdPathComponent, relationPathComponent, endpointPath, idPathComponent]
    }

    func find(_ req: Request) throws -> EventLoopFuture<Model> {
        return try findOn(self.inversedChildrenKeyPath, req: req)
    }

    func findWithRelated(_ req: Request) throws -> EventLoopFuture<(relatedResource: RelatedModel, resource: Model)> {
        return try findWithRelatedOn(self.inversedChildrenKeyPath, req: req)
    }
}

//MARK:- Can be overriden

extension ParentResourceModelProvider {
    func findRelated(_ req: Request) throws -> EventLoopFuture<RelatedModel> {
           return try RelatedModel.query(on: req.db)
                                  .findBy(rootIdComponentKey, from: req)
    }
}

//MARK:- Private

extension ParentResourceModelProvider {
    fileprivate func findOn(_ childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
                            req: Request) throws -> EventLoopFuture<Model> {
        return try findWithRelatedOn(childrenKeyPath, req: req).map { $0.resource }
    }

    fileprivate func findWithRelatedOn(_ childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
                                      req: Request) throws -> EventLoopFuture<(relatedResource: RelatedModel, resource: Model)> {

        return try findRelated(req).flatMapThrowing { relatedResource in
                                    return try relatedResource.query(keyPath: childrenKeyPath, on: req.db)
                                                                .with(self.eagerLoadHandler, for: req)
                                                                .sort(self.sortingHandler, for: req)
                                                                .filter(self.filteringHandler, for: req)
                                                                .findBy(self.idKey, from: req)
                                                                .map { (relatedResource, $0) }}
                                 .flatMap { $0 }
    }
}
