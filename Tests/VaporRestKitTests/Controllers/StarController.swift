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
                .create(using: Star.Input.self)
                .read()
                .update(using: Star.Input.self)
                .patch(using: Star.PatchInput.self)
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


    struct StarForGalaxyNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Star.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Galaxy.$stars, relationName: "contains")
                .create(using: Star.Input.self)
                .read()
                .update(using: Star.Input.self)
                .patch(using: Star.PatchInput.self)
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

    struct StarForGalaxyRelationNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Star.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Galaxy.$stars, relationName: "contains")
                .create(using: Star.Input.self)
                .read()
                .update(using: Star.Input.self)
                .patch(using: Star.PatchInput.self)
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

    struct StarForTagsNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Star.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \StarTag.$stars, relationName: "related")
                .create(using: Star.Input.self)
                .read()
                .update(using: Star.Input.self)
                .patch(using: Star.PatchInput.self)
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

    struct StarForTagsRelationNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Star.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \StarTag.$stars, relationName: "related")
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
