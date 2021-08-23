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
            try ResourceController<StarTag.Output>().create(
                req: req,
                using: StarTag.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try ResourceController<StarTag.Output>().read(
                req: req,
                queryModifier: queryModifier)
        }

        func update(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try ResourceController<StarTag.Output>().update(
                req: req,
                using: StarTag.Input.self,
                queryModifier: queryModifier)
        }

        func delete(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try ResourceController<StarTag.Output>().delete(
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier)
        }

        func patch(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try ResourceController<StarTag.Output>().patch(
                req: req,
                using: StarTag.PatchInput.self,
                queryModifier: queryModifier)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<StarTag.Output>> {
            try ResourceController<StarTag.Output>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct StarTagForStarNestedController {
        let queryModifier: QueryModifier<StarTag> = .empty

        func create(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag.Output>().create(
                req: req,
                using: StarTag.Input.self,
                relationKeyPath: \Star.$starTags)
        }

        func read(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag.Output>().read(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

        func update(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag.Output>().update(
                req: req,
                using: StarTag.Input.self,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

        func delete(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag.Output>().delete(
                req: req,
                using: .defaultDeleter,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

        func patch(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag.Output>().patch(
                req: req,
                using: StarTag.PatchInput.self,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<StarTag.Output>> {
            try RelatedResourceController<StarTag.Output>().getCursorPage(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct StarTagForStarRelationNestedController {
        let queryModifier: QueryModifier<StarTag> = .empty

        func createRelation(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelationsController<StarTag.Output>().createRelation(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelationsController<StarTag.Output>().deleteRelation(
                req: req,
                queryModifier: queryModifier,
                relationKeyPath: \Star.$starTags)
        }

    }
}
