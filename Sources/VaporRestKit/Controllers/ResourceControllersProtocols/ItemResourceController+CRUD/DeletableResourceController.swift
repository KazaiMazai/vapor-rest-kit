//
//  
//  
//
//  Created by Sergey Kazakov on 29.04.2020.
//

import Vapor
import Fluent

protocol DeletableResourceController: ItemResourceControllerProtocol
    where
    Input: ResourceDeleteModel,
    Model == Input.Model {

    associatedtype Input
    associatedtype Model

    func delete(_ req: Request) throws -> EventLoopFuture<Output>
}

extension DeletableResourceController where Self: ResourceModelProvider {
    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        try Input.validate(req)
        let inputModel = try req.content.decode(Input.self)
        let db = req.db
        return try self.find(req)
            .flatMap { inputModel.delete($0, req: req, database: db) }
            .map { Output($0, req: req) }
    }
}



