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



struct StarTagControllers {
    struct StarTagController: VersionableController {
        let queryModifier: QueryModifier<StarTag> = .empty

        var apiV1: APIMethodsProviding {
            return StarTag.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .create(using: StarTag.Input.self)
                .read()
                .update(using: StarTag.Input.self)
                .patch(using: StarTag.PatchInput.self)
                .delete()
                .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }

        struct StarTagControllerV2 {
            let queryModifier: QueryModifier<StarTag> = .empty

            func create(req: Request) throws -> EventLoopFuture<StarTag.Output> {
                try ResourceController<StarTag>().create(
                    req: req,
                    using: StarTag.Input.self)
            }

            func read(req: Request) throws -> EventLoopFuture<StarTag.Output> {
                try ResourceController<StarTag>().read(
                    req: req,
                    queryModifier: queryModifier)
            }

            func update(req: Request) throws -> EventLoopFuture<StarTag.Output> {
                try ResourceController<StarTag>().update(
                    req: req,
                    using: StarTag.Input.self,
                    queryModifier: queryModifier)
            }

            func delete(req: Request) throws -> EventLoopFuture<StarTag.Output> {
                try ResourceController<StarTag>().delete(
                    req: req,
                    using: .defaultDeleter,
                    queryModifier: queryModifier)
            }

            func patch(req: Request) throws -> EventLoopFuture<StarTag.Output> {
                try ResourceController<StarTag>().patch(
                    req: req,
                    using: StarTag.PatchInput.self,
                    queryModifier: queryModifier)
            }

            func index(req: Request) throws -> EventLoopFuture<CursorPage<StarTag.Output>> {
                try ResourceController<StarTag>().getCursorPage(
                    req: req,
                    queryModifier: queryModifier,
                    config: CursorPaginationConfig.defaultConfig)
            }
        }
    }

    struct StarTagForStarNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return StarTag.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Star.$starTags, relationName: "related")
                .create(using: StarTag.Input.self)
                .read()
                .update(using: StarTag.Input.self)
                .patch(using: StarTag.PatchInput.self)
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

    struct StarTagForStarRelationNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return StarTag.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \Star.$starTags, relationName: "related")
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

