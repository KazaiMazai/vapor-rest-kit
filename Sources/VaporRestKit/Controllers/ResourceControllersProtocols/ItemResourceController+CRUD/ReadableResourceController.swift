//
//  
//  
//
//  Created by Sergey Kazakov on 26.04.2020.
//

import Vapor
import Fluent

protocol ReadableResourceController: ItemResourceControllerProtocol {

    func read(_: Request) throws -> EventLoopFuture<Output>
}

extension ReadableResourceController where Self: ResourceModelProvider {
    func read(_ req: Request) throws -> EventLoopFuture<Output> {
        let db = req.db
        return try self.find(req, database: db)
                       .map { Output($0, req: req) }
    }
}


extension ReadableResourceController where Self: ChildrenResourceModelProvider {
    var relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> { .defaultMiddleware }
}

extension ReadableResourceController where Self: ParentResourceModelProvider {
    var relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> { .defaultMiddleware }

}

extension ReadableResourceController where Self: SiblingsResourceModelProvider {
    var relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> { .defaultMiddleware }
}
