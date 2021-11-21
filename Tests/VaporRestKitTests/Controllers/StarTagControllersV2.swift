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
        
        func create(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try ResourceController<StarTag.Output>().create(
                req: req,
                using: StarTag.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try ResourceController<StarTag.Output>().read(
                req: req)
        }

        func update(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try ResourceController<StarTag.Output>().update(
                req: req,
                using: StarTag.Input.self)
        }

        func delete(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try ResourceController<StarTag.Output>().delete(
                req: req)
        }

        func patch(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try ResourceController<StarTag.Output>().patch(
                req: req,
                using: StarTag.PatchInput.self)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<StarTag.Output>> {
            try ResourceController<StarTag.Output>().getCursorPage(
                req: req,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct StarTagForStarNestedController {

        func create(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag.Output>().create(
                req: req,
                using: StarTag.Input.self,
                relationKeyPath: \Star.$starTags)
        }

        func read(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag.Output>().read(
                req: req,
                relationKeyPath: \Star.$starTags)
        }

        func update(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag.Output>().update(
                req: req,
                using: StarTag.Input.self,
                relationKeyPath: \Star.$starTags)
        }

        func delete(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag.Output>().delete(
                req: req,
                relationKeyPath: \Star.$starTags)
        }

        func patch(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelatedResourceController<StarTag.Output>().patch(
                req: req,
                using: StarTag.PatchInput.self,
                relationKeyPath: \Star.$starTags)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<StarTag.Output>> {
            try RelatedResourceController<StarTag.Output>().getCursorPage(
                req: req,
                relationKeyPath: \Star.$starTags)
        }
    }

    struct StarTagForStarRelationNestedController {

        func createRelation(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelationsController<StarTag.Output>().createRelation(
                req: req,
                relationKeyPath: \Star.$starTags)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<StarTag.Output> {
            try RelationsController<StarTag.Output>().deleteRelation(
                req: req,
                relationKeyPath: \Star.$starTags)
        }

    }
}
