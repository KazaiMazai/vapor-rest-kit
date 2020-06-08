//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.05.2020.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent

struct TagControllers {
    struct TagController: VersionableController {

        let todoOwnerGuardMiddleware = RelatedResourceControllerMiddleware<User, Todo>(handler: { (user, todo, req, db) in
            db.eventLoop
                .tryFuture { try req.auth.require(User.self) }
                .guard( { $0.id == todo.user?.id}, else: Abort(.unauthorized))
                .transform(to: (user, todo))
        })


        var apiV1: APIMethodsProviding {
            return Tag.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Todo.$tags, relationName: nil)
                .collection(sorting: SortingUnsupported.self,
                            filtering: FilteringUnsupported.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }

    struct TagsForTodoController: VersionableController {
        var apiV1: APIMethodsProviding {
            let todoOwnerGuardMiddleware = RelatedResourceControllerMiddleware<Tag, Todo> { (tag, todo, req, db) in
                db.eventLoop
                    .tryFuture { try req.auth.require(User.self) }
                    .guard( { $0.id == todo.user?.id}, else: Abort(.unauthorized))
                    .transform(to: (tag, todo))
            }

            return Tag.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Todo.$tags, relationName: nil)
                .create(using: Tag.CreateInput.self, middleware: todoOwnerGuardMiddleware)
                .read()
                .update(using: Tag.UpdateInput.self, middleware: todoOwnerGuardMiddleware)
                .patch(using: Tag.PatchInput.self, middleware: todoOwnerGuardMiddleware)
                .collection(sorting: SortingUnsupported.self,
                            filtering: FilteringUnsupported.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }

    }
}
