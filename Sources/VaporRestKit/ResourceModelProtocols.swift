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

    init(_: Model)
}

public protocol ResourceUpdateModel: Content, Validatable {
    associatedtype Model: Fields

    func update(_: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}

public protocol ResourcePatchModel: Content, Validatable {
    associatedtype Model: Fields

    func patch(_: Model) -> Model
}


