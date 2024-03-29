//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent

struct UserControllers {
    struct UsersController: VersionableController {
        var apiv1: APIMethodsProviding {
            return User.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .create(using: User.Input.self)
                .read()
                .collection(sorting: SortingUnsupported.self,
                            filtering: FilteringUnsupported.self)

        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiv1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }

    struct UsersForTodoController: VersionableController {
        var apiV1: APIMethodsProviding {
            return User.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Todo.$assignees, relationName: "assignees")
                .read()
                .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }

    struct TodoAssigneesRelationController: VersionableController {
        let todoOwnerGuardMiddleware = ControllerMiddleware<User, Todo>(handler: { (user, todo, req, db) in
            db.eventLoop
                .tryFuture { try req.auth.require(User.self) }
                .guard( { $0.id == todo.$user.id}, else: Abort(.unauthorized))
                .transform(to: (user, todo))
        })

        var apiV1: APIMethodsProviding {
            return User.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Todo.$assignees, relationName: "assignees")
                .relation
                .create(with: todoOwnerGuardMiddleware)
                .delete(with: todoOwnerGuardMiddleware)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }
}
