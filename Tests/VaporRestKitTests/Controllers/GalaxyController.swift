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
                .create(using: Galaxy.Input.self)
                .read()
                .update(using: Galaxy.Input.self)
                .patch(using: Galaxy.PatchInput.self)
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

    struct GalaxyForStarsNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Galaxy.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Galaxy.$stars, relationName: "belongs")
                .create(using: Galaxy.Input.self)
                .read()
                .update(using: Galaxy.Input.self)
                .patch(using: Galaxy.PatchInput.self)
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

    struct ExtendableGalaxyForStarsNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Galaxy.ExtendedOutput<Star.Output>
                .controller(eagerLoading: GalaxyControllers.GalaxyEagerLoader.self)
                .related(by: \Galaxy.$stars, relationName: "belongs")
                .create(using: Galaxy.Input.self)
                .read()
                .update(using: Galaxy.Input.self)
                .patch(using: Galaxy.PatchInput.self)
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
                .related(by: \Galaxy.$stars, relationName: "belongs")
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


extension GalaxyControllers {
    struct GalaxyEagerLoader: DynamicEagerLoading {
        typealias Model = Galaxy
        typealias Key = Keys

        func defaultEagerLoading(_ queryBuilder: QueryBuilder<Galaxy>) -> QueryBuilder<Galaxy> {
            return queryBuilder
        }

        enum Keys: String, EagerLoadingKey {
            typealias Model = Galaxy

            case stars

            func eagerLoadFor(_ queryBuilder: QueryBuilder<Galaxy>) -> QueryBuilder<Galaxy> {
                switch self {
                case .stars:
                    return queryBuilder.with(\.$stars)
                }
            }
        }
    }
}
