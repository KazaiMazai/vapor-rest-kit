//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

protocol AuthSiblingsResourceRelationProvider: SiblingsResourceRelationProvider where RelatedModel: Authenticatable {

}

extension AuthSiblingsResourceRelationProvider {
    var rootIdComponentKey: String { "me" }
    var rootIdPathComponent: PathComponent { return PathComponent(stringLiteral: "\(self.rootIdComponentKey)") }

    func findRelated(_ req: Request, database: Database) throws -> EventLoopFuture<RelatedModel> {
        let related = try req.auth.require(RelatedModel.self)
        return req.eventLoop.makeSucceededFuture(related)
    }
}
