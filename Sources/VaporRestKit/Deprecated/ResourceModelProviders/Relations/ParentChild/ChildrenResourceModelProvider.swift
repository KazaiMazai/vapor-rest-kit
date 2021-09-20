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

    var relatedResourceMiddleware: ControllerMiddleware<Model, RelatedModel> { get }
    var relationNamePath: String? { get }
    var childrenKeyPath: ChildrenKeyPath<RelatedModel, Model> { get }

    func findWithRelated(_ req: Request, database: Database) throws -> EventLoopFuture<(resource: Model, relatedResource: RelatedModel)>

    func findRelated(_ req: Request, database: Database) throws -> EventLoopFuture<RelatedModel>

}

extension ChildrenResourceModelProvider {
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
        return try findOn(self.childrenKeyPath, req: req, database: database)
    }

    func findWithRelated(_ req: Request, database: Database) throws -> EventLoopFuture<(resource: Model, relatedResource: RelatedModel)> {
        return try findWithRelatedOn(self.childrenKeyPath, req: req, database: database)
    }
}

//MARK:- Can be overriden

extension ChildrenResourceModelProvider {
    func findRelated(_ req: Request, database: Database) throws -> EventLoopFuture<RelatedModel> {
        return try RelatedModel.query(on: database)
            .find(by: rootIdComponentKey, from: req)
    }
}

//MARK:- Private

extension ChildrenResourceModelProvider {
    fileprivate func findOn(_ childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
                            req: Request,
                            database: Database) throws -> EventLoopFuture<Model> {
        
        return try findWithRelatedOn(childrenKeyPath, req: req, database: database).map { $0.resource }
    }

    fileprivate func findWithRelatedOn(_ childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
                                       req: Request,
                                       database: Database) throws -> EventLoopFuture<(resource: Model, relatedResource: RelatedModel)> {

        return try findRelated(req, database: database)
            .flatMapThrowing { relatedResource in
                try relatedResource.queryRelated(keyPath: childrenKeyPath, on: database)
                    .with(self.eagerLoadHandler, for: req)
                    .sort(self.sortingHandler, for: req)
                    .filter(self.filteringHandler, for: req)
                    .find(by: self.idKey, from: req)
                    .map { ($0, relatedResource) }}
            .flatMap { $0 }
    }
}



