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
            try ResourceController<Star.Output>().create(
                req: req,
                using: Star.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.Output> {
            try ResourceController<Star.Output>().read(
                req: req,
                queryModifier: queryModifier)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.Output> {
            try ResourceController<Star.Output>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.Output> {
            try ResourceController<Star.Output>().delete(
                req: req,
                queryModifier: queryModifier)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.Output> {
            try ResourceController<Star.Output>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
            try ResourceController<Star.Output>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                config: CursorPaginationConfig(
                    allowBackwardPagination: true
                )
            )
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
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().create(
                req: req,
                using: Star.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
                req: req,
                queryModifier: queryModifier)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().delete(
                req: req,
                queryModifier: queryModifier)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().getCursorPage(
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
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().create(
                req: req,
                using: Star.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
                req: req,
                queryModifier: queryModifier)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().delete(
                req: req,
                queryModifier: queryModifier)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().getCursorPage(
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
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().create(
                req: req,
                using: Star.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
                req: req,
                queryModifier: queryModifier)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().delete(
                req: req,
                queryModifier: queryModifier)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().getCursorPage(
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
            try RelatedResourceController<Star.Output>().create(
                req: req,
                using: Star.Input.self,
                relationKeyPath: \StarTag.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().read(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().delete(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
            try RelatedResourceController<Star.Output>().getCursorPage(
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
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().create(
                req: req,
                using: Star.Input.self,
                relationKeyPath: \StarTag.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().delete(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().getCursorPage(
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
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().create(
                req: req,
                using: Star.Input.self,
                relationKeyPath: \StarTag.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().delete(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().getCursorPage(
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
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().create(
                req: req,
                using: Star.Input.self,
                relationKeyPath: \StarTag.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().delete(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \StarTag.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct StarForTagsRelationNestedController {
        func createRelation(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelationsController<Star.Output>().createRelation(
                req: req,
                relationKeyPath: \StarTag.$stars)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelationsController<Star.Output>().deleteRelation(
                req: req,
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
            try RelatedResourceController<Star.Output>().create(
                req: req,
                using: Star.Input.self,
                relationKeyPath: \Star.$planets)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().read(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$planets)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$planets)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().delete(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$planets)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$planets)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
            try RelatedResourceController<Star.Output>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$planets,
                config: CursorPaginationConfig.defaultConfig)
        }
    }
}

extension StarControllersV2.ExtendableStarForGalaxyNestedController {
    enum StarEagerLoadingKeys: String, EagerLoadingQueryKey {
        case galaxy
        case tags

        func eagerLoadFor(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
            switch self {
            case .galaxy:
                return queryBuilder.with(\.$galaxy)
            case .tags:
                return queryBuilder.with(\.$starTags)
            }
        }

        static func eagerLoadEmptyQueryFor(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
            queryBuilder.with(\.$galaxy)
        }
    }

    enum StarsSortingKeys: String, SortingQueryKey {
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

    enum StarsFilterKeys: String, FilterQueryKey {
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
                              lhs: Self,
                              method: DatabaseQuery.Filter.Method,
                              rhs: Self) -> QueryBuilder<Star> {
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

extension StarControllersV2 {
    struct ExtendableStarForGalaxyNestedController {
        let queryModifier: QueryModifier<Star> = {
            .eagerLoading(StarEagerLoadingKeys.self) &
            .sort(using: StarsSortingKeys.self) &
            .filter(StarsFilterKeys.self)
        }()

        func create(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().create(
                req: req,
                using: Star.Input.self,
                relationKeyPath: \Galaxy.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().delete(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().getCursorPage(
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
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().create(
                req: req,
                using: Star.Input.self,
                relationKeyPath: \Galaxy.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().delete(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().getCursorPage(
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
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().create(
                req: req,
                using: Star.Input.self,
                relationKeyPath: \Galaxy.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().delete(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
            try RelatedResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().getCursorPage(
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

        func create(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().create(
                req: req,
                using: Star.Input.self,
                relationKeyPath: \Galaxy.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().read(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().update(
                req: req,
                using: Star.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().delete(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelatedResourceController<Star.Output>().patch(
                req: req,
                using: Star.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
            try RelatedResourceController<Star.Output>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }
    
    struct StarForGalaxyRelationNestedController {
        func createRelation(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelationsController<Star.Output>().createRelation(
                req: req,
                relationKeyPath: \Galaxy.$stars)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<Star.Output> {
            try RelationsController<Star.Output>().deleteRelation(
                req: req,
                relationKeyPath: \Galaxy.$stars)
        }
    }
}
