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

    var deleteHandler: Bool { get}
}

extension DeletableResourceController where Self: ResourceModelProvider {
    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        let db = req.db
        return try self.find(req)
            .flatMap { self.resourceMiddleware.willSave($0, req: req, database: db) }
            .flatMap { $0.delete(force: self.deleteHandler, on: db).transform(to: Output($0, req: req)) } 
    }
}


extension DeletableResourceController where Self: ChildrenResourceModelProvider {
    var middleware: RelationMiddleware<Model, RelatedModel> { return .defaultMiddleware }
}


extension DeletableResourceController where Self: ParentResourceModelProvider {
    var relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel> { return .defaultMiddleware }

}


extension DeletableResourceController where Self: SiblingsResourceModelProvider {
    var middleware: RelationMiddleware<Model, RelatedModel> { return .defaultMiddleware }
}



