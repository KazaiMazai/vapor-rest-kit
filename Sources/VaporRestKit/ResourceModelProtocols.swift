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

//public protocol ResourceDeleteHandler {
//    associatedtype Model: Fluent.Model
//
//    func delete(_: Model, req: Request, database: Database) -> EventLoopFuture<Model>
//}
//
//extension ResourceDeleteHandler {
//    func delete(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
//        return model.delete(on: database).transform(to: model)
//    }
//}

//struct PlainDelete<Model: Fluent.Model>: ResourceDeleteHandler {
//    static func validations(_ validations: inout Validations) { }
//
//}

struct SuccessOutput<Model: Fields>: ResourceOutputModel {
    let success = true

    init(_ model: Model, req: Request) {  }
}

 
public struct Deleter<Model: Fluent.Model> {
    fileprivate let handler: (Model, Request, Database) -> EventLoopFuture<Model>

    public func delete(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
        return handler(model, req, database)
    }

    public static var defaultDeleter: Deleter<Model> {
        return Deleter(handler: { model, _, db in model.delete(on: db).transform(to: model) })
    }
}

public struct RelationMiddleware<Model: Fluent.Model, RelatedModel: Fluent.Model> {
    public typealias Handler = (Model, RelatedModel, Request, Database) -> EventLoopFuture<(Model, RelatedModel)>

    fileprivate let willDetachHandler: Handler
    fileprivate let willAttachHandler: Handler

    public init(willDetach: @escaping Handler = Self.empty, willAttach: @escaping Handler = Self.empty) {
        self.willAttachHandler = willAttach
        self.willDetachHandler = willDetach
    }

    public func willDetach(_ model: Model,
                           relatedModel: RelatedModel,
                           req: Request,
                           database: Database) -> EventLoopFuture<(Model, RelatedModel)> {
        return willDetachHandler(model, relatedModel, req, database)
    }

    public func willAttach(_ model: Model,
                           relatedModel: RelatedModel,
                           req: Request,
                           database: Database) -> EventLoopFuture<(Model, RelatedModel)> {

        return willAttachHandler(model, relatedModel, req, database)
    }


    public static var defaultMiddleware: RelationMiddleware<Model, RelatedModel> {
        return RelationMiddleware(willDetach: empty, willAttach: empty)
    }

    public static var empty: Handler {
        return { model, relatedModel, req, _ in req.eventLoop.makeSucceededFuture((model, relatedModel)) }
    }
}
