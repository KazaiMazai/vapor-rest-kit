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
                .collection(sorting: StarTagControllers.StarsSorting.self, filtering: StarTagControllers.StarsFiltering.self)
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
                .collection(sorting: StarTagControllers.StarsSorting.self, filtering: StarTagControllers.StarsFiltering.self)
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
                .collection(sorting: StarTagControllers.StarsSorting.self, filtering: StarTagControllers.StarsFiltering.self)
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

extension StarTagControllers {
    struct StarsSorting: DynamicSorting {
        typealias Model = Star
        typealias Key = Keys

        enum Keys: String, SortingKey {
            typealias Model = Star

            case title
            case subtitle

            func sortFor(_ queryBuilder: QueryBuilder<Star>, direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<Star> {
                switch self {
                case .title:
                    return queryBuilder.sort(\Star.$title, direction)
                case .subtitle:
                    return queryBuilder.sort(\Star.$subtitle, direction)
                }
            }
        }

        func defaultSorting(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
            return queryBuilder
        }
    }

    struct StarsFiltering: DynamicFiltering {
        typealias Model = Star
        typealias Key = Keys

        func defaultFiltering(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
            //no filter
            return queryBuilder
        }


        enum Keys: String, FilteringKey {
            typealias Model = Star

            case title
            case subtitle
            case size

            func filterFor(queryBuilder: QueryBuilder<Star>,
                           method: DatabaseQuery.Filter.Method,
                           value: String) -> QueryBuilder<Star> {

                switch self {
                case .title:
                    return queryBuilder.filter(\.$title, method, value)
                case .subtitle:
                    return queryBuilder.filter(\.$subtitle, method, value)
                case .size:
                    guard let intValue = Int(value) else {
                        return queryBuilder
                    }
                    return queryBuilder.filter(\.$size, method, intValue)
                }
            }

            static func filterFor(queryBuilder: QueryBuilder<Star>,
                                  lhs: StarTagControllers.StarsFiltering.Keys,
                                  method: DatabaseQuery.Filter.Method,
                                  rhs: StarTagControllers.StarsFiltering.Keys) -> QueryBuilder<Star> {
                switch (lhs, rhs) {
                case (.title, .subtitle):
                    return queryBuilder.filter(\.$title, method, \.$subtitle)
                case (.subtitle, .title):
                    return queryBuilder.filter(\.$subtitle, method, \.$title)
                default:
                    return queryBuilder
                }
            }
        }
    }
}
