//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 19.05.2020.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent

struct GalaxyControllers {
    struct GalaxyController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Galaxy.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .create(input: Galaxy.Input.self)
                .read()
                .update(input: Galaxy.Input.self)
                .patch(input: Galaxy.PatchInput.self)
                .delete()
                .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                let todos = routeBuilder.grouped("todos")
                apiV1.addMethodsTo(todos, on: endpoint)
            }
        }
    }

    struct GalaxyForStarsNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Galaxy.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .relatedWith(childrenKeyPath: \Galaxy.$stars, relationName: "belongs")
                .create(with: Galaxy.Input.self)
                .read()
                .update(with: Galaxy.Input.self)
                .patch(with: Galaxy.PatchInput.self)
                .delete()
                .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }

    struct GalaxyForStarsRelationNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Galaxy.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .relatedWith(childrenKeyPath: \Galaxy.$stars, relationName: "belongs")
                .relation
                .create()
                .delete()
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }
}
