//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 17.05.2020.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent

struct TodoControllers {
    struct TodoController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .read()
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

    struct TodosForTagsController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Tag.$relatedTodos, relationName: "related")
                .read()
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

    struct TodosForTagsRelationController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Tag.$relatedTodos, relationName: nil)
                .read()
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

    struct MyTodosController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \User.$todos, relationName: "owns")
                .create(using: Todo.Input.self, authenticatable: User.self)
                .read(authenticatable: User.self)
                .update(using: Todo.Input.self, authenticatable: User.self)
                .patch(using: Todo.PatchInput.self, authenticatable: User.self)
                .delete(authenticatable: User.self)
                .collection(sorting: SortingUnsupported.self,
                            filtering: FilteringUnsupported.self,
                            authenticatable: User.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }

    struct TodosForUserController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \User.$todos, relationName: "owns")
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

    struct AssignedTodosForUserController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \User.$assignedTodos, relationName: "assigned")
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
}



