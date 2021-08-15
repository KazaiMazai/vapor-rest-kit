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


struct UserControllersV2 {
    struct UsersController {
        func create(req: Request) throws -> EventLoopFuture<User.Output> {
            try ResourceController<User>().create(
                req: req,
                using: User.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<User.Output> {
            try ResourceController<User>().read(
                req: req,
                queryModifier: .empty)
        }
    }

    struct UsersForTodoController {
        func read(req: Request) throws -> EventLoopFuture<User.Output> {
            try RelatedResourceController<User>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                siblingKeyPath: \Todo.$assignees)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<User.Output>> {
            try RelatedResourceController<User>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                siblingKeyPath: \Todo.$assignees,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct TodoAssigneesRelationController {
        let todoOwnerGuardMiddleware = RelatedResourceControllerMiddleware<User, Todo>(handler: { (user, todo, req, db) in
            db.eventLoop
                .tryFuture { try req.auth.require(User.self) }
                .guard( { $0.id == todo.$user.id}, else: Abort(.unauthorized))
                .transform(to: (user, todo))
        })

        func createRelation(req: Request) throws -> EventLoopFuture<User.Output> {
            try RelationsController<User>().createRelation(
                resolver: .byIdKeys(),
                req: req,
                willAttach: todoOwnerGuardMiddleware,
                queryModifier: .empty,
                siblingKeyPath: \Todo.$assignees)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<User.Output> {
            try RelationsController<User>().deleteRelation(
                resolver: .byIdKeys(),
                req: req,
                willDetach: todoOwnerGuardMiddleware,
                queryModifier: .empty,
                siblingKeyPath: \Todo.$assignees)
        }
    }
}
