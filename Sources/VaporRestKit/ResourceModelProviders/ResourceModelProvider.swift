//
//  
//  
//
//  Created by Sergey Kazakov on 27.04.2020.
//

import Fluent
import Vapor

protocol ResourceModelProvider where EagerLoading.Model == Model, Sorting.Model == Model, Filtering.Model == Model  {
    associatedtype Model
    associatedtype Sorting: SortProvider
    associatedtype EagerLoading: EagerLoadProvider
    associatedtype Filtering: FilterProvider

    var idKey: String { get }
    var idPathComponent: PathComponent { get }

    var eagerLoadHandler: EagerLoading { get }
    var sortingHandler: Sorting { get }
    var filteringHandler: Filtering { get } 

    func find(_: Request, database: Database) throws -> EventLoopFuture<Model>

    func resourcePathFor(endpoint: String) -> [PathComponent]

    func idResourcePathFor(endpoint: String) -> [PathComponent]
}

extension ResourceModelProvider where Model.IDValue: LosslessStringConvertible {
    var idKey: String { Model.schema }
    var idPathComponent: PathComponent { return PathComponent(stringLiteral: ":\(self.idKey)") }

    var sortingHandler: Sorting { Sorting() }

    var eagerLoadHandler: EagerLoading { EagerLoading() }

    var filteringHandler: Filtering { Filtering() }

    func resourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [endpointPath]
    }

    func idResourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [endpointPath, idPathComponent]
    }

    func find(_ req: Request, database: Database) throws -> EventLoopFuture<Model> {
        return try Model.query(on: database)
                        .with(self.eagerLoadHandler, for: req)
                        .sort(self.sortingHandler, for: req)
                        .filter(self.filteringHandler, for: req)
                        .findBy(idKey, from: req)
    }
}
