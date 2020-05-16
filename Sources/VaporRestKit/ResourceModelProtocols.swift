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
    associatedtype Model: Fluent.Model

    func delete(_: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}

extension ResourceDeleteModel {
    func delete(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
        return model.delete(on: database).transform(to: model)
    }
}

struct PlainDelete<Model: Fluent.Model>: ResourceDeleteModel {
    static func validations(_ validations: inout Validations) { }

}

struct SuccessOutput<Model: Fields>: ResourceOutputModel {
    let success = true

    init(_ model: Model, req: Request) {  }
}

 
