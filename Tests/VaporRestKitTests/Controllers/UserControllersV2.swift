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
            try ResourceController<User.Output>().create(
                req: req,
                using: User.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<User.Output> {
            try ResourceController<User.Output>().read(
                req: req)
        }
    }

    struct UsersForTodoController {
        func read(req: Request) throws -> EventLoopFuture<User.Output> {
            try RelatedResourceController<User.Output>().read(
                req: req,
                relationKeyPath: \Todo.$assignees)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<User.Output>> {
            try RelatedResourceController<User.Output>().getCursorPage(
                req: req,
                relationKeyPath: \Todo.$assignees,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct TodoAssigneesRelationController {
        let todoOwnerGuardMiddleware = ControllerMiddleware<User, Todo>(handler: { (user, todo, req, db) in
            db.eventLoop
                .tryFuture { try req.auth.require(User.self) }
                .guard({ $0.id == todo.$user.id }, else: Abort(.unauthorized))
                .transform(to: (user, todo))
        })

        func addAssignee(req: Request) throws -> EventLoopFuture<User.Output> {
            try RelationsController<User.Output>().createRelation(
                req: req,
                willAttach: todoOwnerGuardMiddleware,
                relationKeyPath: \Todo.$assignees)
        }

        func removeAssignee(req: Request) throws -> EventLoopFuture<User.Output> {
            try RelationsController<User.Output>().deleteRelation(
                req: req,
                willDetach: todoOwnerGuardMiddleware,
                relationKeyPath: \Todo.$assignees)
        }
    }
}
