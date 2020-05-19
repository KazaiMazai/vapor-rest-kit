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


struct StarControllers {
    struct StarController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Star.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .create(input: Star.Input.self)
                .read()
                .update(input: Star.Input.self)
                .patch(input: Star.PatchInput.self)
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


    struct StarForStarsNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Star.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .relatedWith(childrenKeyPath: \Galaxy.$stars, relationName: "contains")
                .create(with: Star.Input.self)
                .read()
                .update(with: Star.Input.self)
                .patch(with: Star.PatchInput.self)
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

    struct StarForStarsRelationNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Star.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .relatedWith(childrenKeyPath: \Galaxy.$stars, relationName: "contains")
                .create(with: Star.Input.self)
                .read()
                .update(with: Star.Input.self)
                .patch(with: Star.PatchInput.self)
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
}
