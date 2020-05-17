//
//  
//  
//
//  Created by Sergey Kazakov on 29.04.2020.
//

import Vapor
import Fluent

protocol DeletableResourceController: ItemResourceControllerProtocol {
    func delete(_ req: Request) throws -> EventLoopFuture<Output>

    var useForcedDelete: Bool { get}
}

extension DeletableResourceController where Self: ResourceModelProvider {
    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        let db = req.db
        return try self.find(req)
            .flatMap { self.resourceMiddleware.willSave($0, req: req, database: db) }
            .flatMap { $0.delete(force: self.useForcedDelete, on: db).transform(to: Output($0, req: req)) } 
    }
}


