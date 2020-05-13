//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 03.05.2020.
//

import Vapor
import Fluent

protocol AuthSiblingsResourceModelProviding: SiblingsResourceModelProviding where RelatedModel: Authenticatable {

}

extension AuthSiblingsResourceModelProviding {
    var rootIdComponentKey: String { "me" }
    var rootIdPathComponent: PathComponent { return PathComponent(stringLiteral: "\(self.rootIdComponentKey)") }

    func findRelated(_ req: Request) throws -> EventLoopFuture<RelatedModel> {
        let related = try req.auth.require(RelatedModel.self)
        return req.eventLoop.makeSucceededFuture(related)
    }
}
