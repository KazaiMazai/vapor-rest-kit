//
//  
//  
//
//  Created by Sergey Kazakov on 26.04.2020.
//

import Vapor
import Fluent

public protocol ResourceOutputModel: Content {
    associatedtype Model: Fields

    init(_: Model, req: Request)
}

public protocol ResourceUpdateModel: Content, Validatable {
    associatedtype Model: Fields

    func update(_: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}

public protocol ResourcePatchModel: Content, Validatable {
    associatedtype Model: Fields
 
    func patch(_: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}

public protocol ResourceDeleteModel: Content, Validatable {
    associatedtype Model: Fields

    func delete(_: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}

struct PlainDelete<Model: Fields>: ResourceDeleteModel {
    static func validations(_ validations: inout Validations) { }

    func delete(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
        return req.eventLoop.makeSucceededFuture(model)
    }
}

struct SuccessOutput<Model: Fields>: ResourceOutputModel {
    let success = true

    init(_ model: Model, req: Request) {  }
}

 
