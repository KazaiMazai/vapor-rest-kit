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
            try RelatedResourceController<Tag>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                siblingKeyPath: \Todo.$tags,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct TagsForTodoController {
        let todoOwnerGuardMiddleware = RelatedResourceControllerMiddleware<Tag, Todo> { (tag, todo, req, db) in
            db.eventLoop
                .tryFuture { try req.auth.require(User.self) }
                .guard( { $0.id == todo.user?.id}, else: Abort(.unauthorized))
                .transform(to: (tag, todo))
        }

        func create(req: Request) throws -> EventLoopFuture<Tag.Output> {
            try RelatedResourceController<Tag>().create(
                resolver: .byIdKeys(),
                req: req,
                using: Tag.CreateInput.self,
                willAttach: todoOwnerGuardMiddleware,
                siblingKeyPath: \Todo.$tags)
        }

        func read(req: Request) throws -> EventLoopFuture<Tag.Output> {
            try RelatedResourceController<Tag>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                siblingKeyPath: \Todo.$tags)
        }

        func update(req: Request) throws -> EventLoopFuture<Tag.Output> {
            try RelatedResourceController<Tag>().update(
                resolver: .byIdKeys(),
                req: req,
                using: Tag.UpdateInput.self,
                willSave: todoOwnerGuardMiddleware,
                queryModifier: .empty,
                siblingKeyPath: \Todo.$tags)
        }

        func patch(req: Request) throws -> EventLoopFuture<Tag.Output> {
            try RelatedResourceController<Tag>().patch(
                resolver: .byIdKeys(),
                req: req,
                using: Tag.PatchInput.self,
                willSave: todoOwnerGuardMiddleware,
                queryModifier: .empty,
                siblingKeyPath: \Todo.$tags)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Tag.Output>> {
            try RelatedResourceController<Tag>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                siblingKeyPath: \Todo.$tags,
                config: CursorPaginationConfig.defaultConfig)
        }
    }
}
