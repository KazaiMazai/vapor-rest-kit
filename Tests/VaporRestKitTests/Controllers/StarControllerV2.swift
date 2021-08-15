//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.08.2021.
//

import Foundation

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent


struct StarControllersV2 {
    struct StarController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: EagerLoadingUnsupported(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.Output> {
            try ResourceController<Star>().create(
                req: req,
                using: Star.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.Output> {
            try ResourceController<Star>().read(
                req: req,
                queryModifier: queryModifier)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.Output> {
            try ResourceController<Star>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.Output> {
            try ResourceController<Star>().delete(
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.Output> {
            try ResourceController<Star>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
            try ResourceController<Star>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct ExtendableStarController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: StarTagControllers.ExtendableStarEagerLoading(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().create(
                req: req,
                using: Star.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().read(
                req: req,
                queryModifier: queryModifier)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().delete(
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try ResourceController<Star>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct FullStarController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: StarTagControllers.FullStarEagerLoading(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().create(
                req: req,
                using: Star.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().read(
                req: req,
                queryModifier: queryModifier)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().delete(
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try ResourceController<Star>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct DynamicStarController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: StarTagControllers.DynamicStarEagerLoading(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().create(
                req: req,
                using: Star.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().read(
                req: req,
                queryModifier: queryModifier)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().delete(
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try ResourceController<Star>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                config: CursorPaginationConfig.defaultConfig)
        }
    }


    struct StarForTagsNestedController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: EagerLoadingUnsupported(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                relationKeyPath: \StarTag.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
            try RelatedResourceController<Star>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct DynamicStarForTagsNestedController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: StarTagControllers.DynamicStarEagerLoading(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                relationKeyPath: \StarTag.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct ExtendableStarForTagsNestedController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: StarTagControllers.ExtendableStarEagerLoading(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                relationKeyPath: \StarTag.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct FullStarForTagsNestedController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: StarTagControllers.FullStarEagerLoading(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                relationKeyPath: \StarTag.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct StarForTagsRelationNestedController {
        func createRelation(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelationsController<Star>().createRelation(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \StarTag.$stars)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelationsController<Star>().deleteRelation(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \StarTag.$stars)
        }
    }
}

extension StarControllersV2  {
    struct StarForPlanetNestedController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: EagerLoadingUnsupported(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                relationKeyPath: \Star.$planets)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$planets)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$planets)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$planets)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$planets)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
            try RelatedResourceController<Star>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$planets,
                config: CursorPaginationConfig.defaultConfig)
        }
    }
}

extension StarControllersV2 {
    struct ExtendableStarForGalaxyNestedController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Star.ExtendedOutput<Galaxy.Output, StarTag.Output>
                .controller(eagerLoading: StarTagControllers.ExtendableStarEagerLoading.self)
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

        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: StarTagControllers.ExtendableStarEagerLoading(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                relationKeyPath: \Galaxy.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct FullStarForGalaxyNestedController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: StarTagControllers.FullStarEagerLoading(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                relationKeyPath: \Galaxy.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct DynamicStarForGalaxyNestedController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: StarTagControllers.DynamicStarEagerLoading(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                relationKeyPath: \Galaxy.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }


    struct StarForGalaxyNestedController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: EagerLoadingUnsupported(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                relationKeyPath: \Galaxy.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct StarForGalaxyRelationNestedController {
        var queryModifier: QueryModifier<Star> {
            QueryModifier.using(
                eagerLoadProvider: EagerLoadingUnsupported(),
                sortProvider: StarTagControllers.StarsSorting(),
                filterProvider: StarTagControllers.StarsFiltering())
        }

        func createRelation(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelationsController<Star>().createRelation(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Galaxy.$stars)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelationsController<Star>().deleteRelation(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Galaxy.$stars)
        }
    }
}
