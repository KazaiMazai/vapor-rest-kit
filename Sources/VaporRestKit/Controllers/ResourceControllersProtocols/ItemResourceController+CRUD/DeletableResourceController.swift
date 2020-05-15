//
//  
//  
//
//  Created by Sergey Kazakov on 29.04.2020.
//

import Vapor
import Fluent

protocol DeletableResourceController: ItemResourceControllerProtocol {
    func delete(_: Request) throws -> EventLoopFuture<HTTPStatus>
}

extension DeletableResourceController where Self: ResourceModelProvider {
    func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try self.find(req)
                .flatMap { $0.delete(on: req.db) }
                .map { .ok }
    }
}



