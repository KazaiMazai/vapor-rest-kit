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

    var relatedResourceMiddleware: RelatedResourceMiddleware<Model, RelatedModel> { get }
    var relationNamePath: String? { get }
    var inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel> { get }

    func findWithRelated(_ req: Request, database: Database) throws -> EventLoopFuture<(relatedResource: RelatedModel, resource: Model)>

    func findRelated(_ req: Request, database: Database) throws -> EventLoopFuture<RelatedModel>
}

extension ParentResourceModelProvider {
    var idKey: String { Model.schema }
    var idPathComponent: PathComponent { return PathComponent(stringLiteral: ":\(self.idKey)") }

    var rootIdComponentKey: String { RelatedModel.schema }
    var rootIdPathComponent: PathComponent { return PathComponent(stringLiteral: ":\(self.rootIdComponentKey)") }
    var relationPathComponent: PathComponent? {
        guard let path = self.relationNamePath else {
            return nil
        }

        return PathComponent(stringLiteral: "\(path)")
    }

    func resourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [rootIdPathComponent, relationPathComponent, endpointPath].compactMap { $0 }
    }

    func idResourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [rootIdPathComponent, relationPathComponent, endpointPath, idPathComponent].compactMap { $0 }
    }

    func find(_ req: Request, database: Database) throws -> EventLoopFuture<Model> {
        return try findOn(self.inversedChildrenKeyPath, req: req, database: database)
    }

    func findWithRelated(_ req: Request, database: Database) throws -> EventLoopFuture<(relatedResource: RelatedModel, resource: Model)> {
        return try findWithRelatedOn(self.inversedChildrenKeyPath, req: req, database: database)
    }
}

//MARK:- Can be overriden

extension ParentResourceModelProvider {
    func findRelated(_ req: Request, database: Database) throws -> EventLoopFuture<RelatedModel> {
        return try RelatedModel.query(on: database)
            .find(by: rootIdComponentKey, from: req)
    }
}

//MARK:- Private

extension ParentResourceModelProvider {
    fileprivate func findOn(_ childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
                            req: Request,
                            database: Database) throws -> EventLoopFuture<Model> {

        return try findWithRelatedOn(childrenKeyPath,
                                     req: req,
                                     database: database).map { $0.resource }
    }

    fileprivate func findWithRelatedOn(_ childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
                                       req: Request,
                                       database: Database) throws -> EventLoopFuture<(relatedResource: RelatedModel, resource: Model)> {

        return try findRelated(req, database: database)
            .flatMapThrowing { relatedResource in
                try relatedResource.queryRelated(keyPath: childrenKeyPath, on: database)
                    .with(self.eagerLoadHandler, for: req)
                    .sort(self.sortingHandler, for: req)
                    .filter(self.filteringHandler, for: req)
                    .find(by: self.idKey, from: req)
                    .map { (relatedResource, $0) }}
            .flatMap { $0 }
    }
}
