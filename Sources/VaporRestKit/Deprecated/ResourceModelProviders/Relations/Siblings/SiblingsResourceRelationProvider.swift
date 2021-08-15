//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

protocol SiblingsResourceRelationProvider: SiblingsResourceModelProvider {

}

extension SiblingsResourceRelationProvider {
    func find(_ req: Request, database: Database) throws -> EventLoopFuture<Model> {
        return try Model.query(on: database)
                        .with(self.eagerLoadHandler, for: req)
                        .sort(self.sortingHandler, for: req)
                        .filter(self.filteringHandler, for: req)
                        .find(by: idKey, from: req)
    }
    
    func idResourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        let relationPath = PathComponent(stringLiteral: "relation")
        return [rootIdPathComponent, relationPathComponent, endpointPath, idPathComponent, relationPath].compactMap { $0 }
    }
}
