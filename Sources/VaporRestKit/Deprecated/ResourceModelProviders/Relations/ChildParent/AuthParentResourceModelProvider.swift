//
//  
//  
//
//  Created by Sergey Kazakov on 02.05.2020.
//

import Vapor
import Fluent

protocol AuthParentResourceModelProvider: ParentResourceModelProvider where RelatedModel: Authenticatable {

}

extension AuthParentResourceModelProvider {
    var rootIdComponentKey: String { "me" }
    var rootIdPathComponent: PathComponent { return PathComponent(stringLiteral: "\(self.rootIdComponentKey)") }

    func findRelated(_ req: Request, database: Database) throws -> EventLoopFuture<RelatedModel> {
        let related = try req.auth.require(RelatedModel.self)
        return req.eventLoop.makeSucceededFuture(related)
    }
}



