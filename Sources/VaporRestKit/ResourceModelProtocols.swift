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

    func update(_: Model) throws -> Model
}

public protocol ResourcePatchModel: Content, Validatable {
    associatedtype Model: Fields

    func patch(_: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}

struct SuccessOutput<Model: Fields>: ResourceOutputModel {
    let success = true

    init(_ model: Model, req: Request) {  }
}

public struct ResourceMiddleware<Model: Fluent.Model> {
    public typealias Handler = (Model, Request, Database) -> EventLoopFuture<Model>

    fileprivate let willSaveHandler: Handler

    public init(willSave: @escaping Handler = Self.empty) {
        self.willSaveHandler = willSave
    }

    public func willSave(_ model: Model,
                         req: Request,
                         database: Database) -> EventLoopFuture<Model> {

        return willSaveHandler(model, req, database)
    }

    public static var defaultMiddleware: ResourceMiddleware<Model> {
        return ResourceMiddleware(willSave: empty)
    }

    public static var empty: Handler {
        return { model, req, _ in req.eventLoop.makeSucceededFuture(model) }
    }
}

public struct RelationMiddleware<Model: Fluent.Model, RelatedModel: Fluent.Model> {
    public typealias Handler = (Model, RelatedModel, Request, Database) -> EventLoopFuture<(Model, RelatedModel)>

    fileprivate let willSaveHandler: Handler

    public init(willSave: @escaping Handler = Self.empty) {
        self.willSaveHandler = willSave
    }

    public func willSave(_ model: Model,
                         relatedModel: RelatedModel,
                         req: Request,
                         database: Database) -> EventLoopFuture<(Model, RelatedModel)> {
        return willSaveHandler(model, relatedModel, req, database)
    }


    public static var defaultMiddleware: RelationMiddleware<Model, RelatedModel> {
        return RelationMiddleware(willSave: empty)
    }

    public static var empty: Handler {
        return { model, relatedModel, req, _ in req.eventLoop.makeSucceededFuture((model, relatedModel)) }
    }
}
