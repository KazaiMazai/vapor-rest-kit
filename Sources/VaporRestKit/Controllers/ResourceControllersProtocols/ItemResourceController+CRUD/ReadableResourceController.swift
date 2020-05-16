//
//  
//  
//
//  Created by Sergey Kazakov on 26.04.2020.
//

import Vapor
import Fluent

protocol ReadableResourceController: ItemResourceControllerProtocol {
    associatedtype Output
    associatedtype Model

    func read(_: Request) throws -> EventLoopFuture<Output>
}

extension ReadableResourceController where Self: ResourceModelProvider {
    func read(_ req: Request) throws -> EventLoopFuture<Output> {
        return try self.find(req)
                       .map { Output($0, req: req) }
    }
}

extension ReadableResourceController where Self: ChildrenResourceModelProvider {
    var middleware: RelationMiddleware<Model, RelatedModel> { return .defaultMiddleware }
}


extension ReadableResourceController where Self: ParentResourceModelProvider {
    var middleware: RelationMiddleware<Model, RelatedModel> { return .defaultMiddleware }

}


extension ReadableResourceController where Self: SiblingsResourceModelProvider {
    var middleware: RelationMiddleware<Model, RelatedModel> { return .defaultMiddleware }
}

