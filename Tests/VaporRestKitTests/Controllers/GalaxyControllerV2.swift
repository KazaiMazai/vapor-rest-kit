//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.08.2021.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent

struct GalaxyControllersV2 {
    struct GalaxyController {
        var queryModifier: QueryModifier<Galaxy> {
            QueryModifier.using(
                eagerLoadProvider: EagerLoadingUnsupported(),
                sortProvider: GalaxyControllers.GalaxySorting(),
                filterProvider: FilteringUnsupported<Galaxy>())
        }

        func create(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try ResourceController<Galaxy>().create(
                req: req,
                using: Galaxy.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try ResourceController<Galaxy>().read(
                req: req,
                queryModifier: queryModifier)
        }

        func update(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try ResourceController<Galaxy>().update(
                req: req,
                using: Galaxy.Input.self,
                queryModifier: queryModifier)
        }

        func delete(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try ResourceController<Galaxy>().delete(
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier)
        }

        func patch(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try ResourceController<Galaxy>().patch(
                req: req,
                using: Galaxy.PatchInput.self,
                queryModifier: queryModifier)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Galaxy.Output>> {
            try ResourceController<Galaxy>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct GalaxyForStarsNestedController {
        var queryModifier: QueryModifier<Galaxy> {
            QueryModifier.using(
                eagerLoadProvider: EagerLoadingUnsupported(),
                sortProvider: SortingUnsupported(),
                filterProvider: FilteringUnsupported())
        }

        func create(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try RelatedResourceController<Galaxy>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Galaxy.Input.self,
                relationKeyPath: \Galaxy.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try RelatedResourceController<Galaxy>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try RelatedResourceController<Galaxy>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Galaxy.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try RelatedResourceController<Galaxy>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try RelatedResourceController<Galaxy>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Galaxy.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Galaxy.Output>> {
            try RelatedResourceController<Galaxy>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct ExtendableGalaxyForStarsNestedController {
        var queryModifier: QueryModifier<Galaxy> {
            QueryModifier.using(
                eagerLoadProvider: GalaxyControllers.GalaxyEagerLoader(),
                sortProvider: SortingUnsupported(),
                filterProvider: FilteringUnsupported())
        }

        func create(req: Request) throws -> EventLoopFuture<Galaxy.ExtendedOutput<Star.Output>> {
            try RelatedResourceController<Galaxy>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Galaxy.Input.self,
                relationKeyPath: \Galaxy.$stars)
        }

        func read(req: Request) throws -> EventLoopFuture<Galaxy.ExtendedOutput<Star.Output>> {
            try RelatedResourceController<Galaxy>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func update(req: Request) throws -> EventLoopFuture<Galaxy.ExtendedOutput<Star.Output>> {
            try RelatedResourceController<Galaxy>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Galaxy.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func delete(req: Request) throws -> EventLoopFuture<Galaxy.ExtendedOutput<Star.Output>> {
            try RelatedResourceController<Galaxy>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func patch(req: Request) throws -> EventLoopFuture<Galaxy.ExtendedOutput<Star.Output>> {
            try RelatedResourceController<Galaxy>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Galaxy.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Galaxy.ExtendedOutput<Star.Output>>> {
            try RelatedResourceController<Galaxy>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Galaxy.$stars,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct GalaxyForStarsRelationNestedController {
        func createRelation(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try RelationsController<Galaxy>().createRelation(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Galaxy.$stars)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
            try RelationsController<Galaxy>().deleteRelation(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Galaxy.$stars)
        }
    }
}
