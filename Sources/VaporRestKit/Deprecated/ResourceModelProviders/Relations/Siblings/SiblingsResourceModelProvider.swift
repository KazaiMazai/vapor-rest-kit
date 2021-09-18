//
//  
//  
//
//  Created by Sergey Kazakov on 02.05.2020.
//

import Fluent
import Vapor

protocol SiblingsResourceModelProvider: ResourceModelProvider
    where Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    Through: Fluent.Model,
RelatedModel.IDValue: LosslessStringConvertible {

    associatedtype Model
    associatedtype RelatedModel
    associatedtype Through

    var rootIdComponentKey: String { get }
    var rootIdPathComponent: PathComponent { get }

    var relatedResourceMiddleware: ControllerMiddleware<Model, RelatedModel> { get }
    var relationNamePath: String? { get }
    var siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through> { get }

    func findWithRelated(_ req: Request, database: Database) throws -> EventLoopFuture<(resource: Model, relatedResoure: RelatedModel)>

    func findRelated(_ req: Request, database: Database) throws -> EventLoopFuture<RelatedModel>

}

extension SiblingsResourceModelProvider {
    var idKey: String { Model.schema }
    var idPathComponent: PathComponent { return PathComponent(stringLiteral: ":\(self.idKey)") }
    var rootIdComponentKey: String { RelatedModel.schema }
    var rootIdPathComponent: PathComponent { return PathComponent(stringLiteral: ":\(self.rootIdComponentKey)") }

    var relationPathComponent: PathComponent? { return self.relationNamePath.map { PathComponent(stringLiteral: "\($0)") } }

    func resourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [rootIdPathComponent, relationPathComponent, endpointPath].compactMap { $0 }
    }

    func idResourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [rootIdPathComponent, relationPathComponent, endpointPath, idPathComponent].compactMap { $0 }
    }

    func find(_ req: Request, database: Database) throws -> EventLoopFuture<Model> {
        return try findOn(self.siblingKeyPath, req: req, database: database)
    }

    func findWithRelated(_ req: Request, database: Database) throws -> EventLoopFuture<(resource: Model, relatedResoure: RelatedModel)> {
        return try findWithRelatedOn(self.siblingKeyPath, req: req, database: database)
    }
}

//MARK:- Can be overriden

extension SiblingsResourceModelProvider {
    func findRelated(_ req: Request, database: Database) throws -> EventLoopFuture<RelatedModel> {
        return try RelatedModel.query(on: database)
            .find(by: rootIdComponentKey, from: req)
    }
}

//MARK:- Private

extension SiblingsResourceModelProvider {
    fileprivate func findOn(_ siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>,
                            req: Request,
                            database: Database) throws -> EventLoopFuture<Model> {

        return try findWithRelatedOn(siblingKeyPath,
                                     req: req,
                                     database: database).map { $0.resource }
    }

    fileprivate func findWithRelatedOn(_ siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>,
                                       req: Request,
                                       database: Database) throws -> EventLoopFuture<(resource: Model, relatedResoure: RelatedModel)> {

        return try findRelated(req, database: database)
            .flatMapThrowing { relatedResoure in
                try relatedResoure.queryRelated(keyPath: siblingKeyPath, on: database)
                    .with(self.eagerLoadHandler, for: req)
                    .sort(self.sortingHandler, for: req)
                    .filter(self.filteringHandler, for: req)
                    .find(by: self.idKey, from: req)
                    .map { ($0, relatedResoure) }}
            .flatMap { $0 }
    }
}

