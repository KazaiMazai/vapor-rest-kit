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

struct TagControllersV2 {
    struct TagController {
        func index(req: Request) throws -> EventLoopFuture<CursorPage<Tag.Output>> {
            try RelatedResourceController<Tag.Output>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Todo.$tags,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct TagsForTodoController {
        let todoOwnerGuardMiddleware = RelatedResourceMiddleware<Tag, Todo> { (tag, todo, req, db) in
            db.eventLoop
                .tryFuture { try req.auth.require(User.self) }
                .guard( { $0.id == todo.user?.id}, else: Abort(.unauthorized))
                .transform(to: (tag, todo))
        }

        func create(req: Request) throws -> EventLoopFuture<Tag.Output> {
            try RelatedResourceController<Tag.Output>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Tag.CreateInput.self,
                willAttach: todoOwnerGuardMiddleware,
                relationKeyPath: \Todo.$tags)
        }

        func read(req: Request) throws -> EventLoopFuture<Tag.Output> {
            try RelatedResourceController<Tag.Output>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Todo.$tags)
        }

        func update(req: Request) throws -> EventLoopFuture<Tag.Output> {
            try RelatedResourceController<Tag.Output>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Tag.UpdateInput.self,
                willSave: todoOwnerGuardMiddleware,
                queryModifier: .empty,
                relationKeyPath: \Todo.$tags)
        }

        func patch(req: Request) throws -> EventLoopFuture<Tag.Output> {
            try RelatedResourceController<Tag.Output>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Tag.PatchInput.self,
                willSave: todoOwnerGuardMiddleware,
                queryModifier: .empty,
                relationKeyPath: \Todo.$tags)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Tag.Output>> {
            try RelatedResourceController<Tag.Output>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Todo.$tags,
                config: CursorPaginationConfig.defaultConfig)
        }
    }
}
