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

struct StarTagControllersV2 {
    struct StarTagController {
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

    struct StarTagForStarNestedController {
        let queryModifier: QueryModifier<StarTag> = .empty

        func create(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag>().create(
                resolver: .byIdKeys(),
                req: req,
                using: StarTag.Input.self,
                relationKeyPath: \Star.$starTags)
        }

        func read(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

        func update(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag>().update(
                resolver: .byIdKeys(),
                req: req,
                using: StarTag.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

        func delete(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag>().delete(
                resolver: .byIdKeys(),
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

        func patch(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: StarTag.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<StarTag.Output>> {
            try RelatedResourceController<StarTag>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct StarTagForStarRelationNestedController {
        let queryModifier: QueryModifier<StarTag> = .empty

        func createRelation(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelationsController<StarTag>().createRelation(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelationsController<StarTag>().deleteRelation(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

    }
}
