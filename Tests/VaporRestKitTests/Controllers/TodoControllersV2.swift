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

struct TodoControllersV2 {
    struct TodoController {
        func create(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try ResourceController<Todo.Output>().create(
                req: req,
                using: Todo.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try ResourceController<Todo.Output>().read(
                req: req,
                queryModifier: .empty)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Todo.Output>> {
            try ResourceController<Todo.Output>().getCursorPage(
                req: req,
                queryModifier: .empty,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct TodosForTagsController {
        func read(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelatedResourceController<Todo.Output>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Tag.$relatedTodos)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Todo.Output>> {
            try RelatedResourceController<Todo.Output>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Tag.$relatedTodos,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct TodosForTagsRelationController {
        func createRelation(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelationsController<Todo.Output>().createRelation(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Tag.$relatedTodos)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelationsController<Todo.Output>().deleteRelation(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \Tag.$relatedTodos)
        }
    }

    struct MyTodosController {
        func create(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelatedResourceController<Todo.Output>().create(
                resolver: .requireAuth(),
                req: req,
                using: Todo.Input.self,
                relationKeyPath: \User.$todos)
        }

        func read(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelatedResourceController<Todo.Output>().read(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$todos)
        }

        func update(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelatedResourceController<Todo.Output>().update(
                resolver: .requireAuth(),
                req: req,
                using: Todo.Input.self,
                queryModifier: .empty,
                relationKeyPath: \User.$todos)
        }

        func delete(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelatedResourceController<Todo.Output>().delete(
                resolver: .requireAuth(),
                req: req,
                using: .defaultDeleter,
                queryModifier: .empty,
                relationKeyPath: \User.$todos)
        }

        func patch(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelatedResourceController<Todo.Output>().patch(
                resolver: .requireAuth(),
                req: req,
                using: Todo.PatchInput.self,
                queryModifier: .empty,
                relationKeyPath: \User.$todos)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Todo.Output>> {
            try RelatedResourceController<Todo.Output>().getCursorPage(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$todos,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct MyTodosRelationController {
        func createRelation(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelationsController<Todo.Output>().createRelation(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$todos)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelationsController<Todo.Output>().deleteRelation(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$todos)
        }
    }

    struct TodosForUserController {
        func read(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelatedResourceController<Todo.Output>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$todos)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Todo.Output>> {
            try RelatedResourceController<Todo.Output>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$todos,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct AssignedTodosForUserController {
        func read(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelatedResourceController<Todo.Output>().read(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$assignedTodos)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Todo.Output>> {
            try RelatedResourceController<Todo.Output>().getCursorPage(
                resolver: .byIdKeys(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$assignedTodos,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct MyAssignedTodosForUserController {
        func read(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelatedResourceController<Todo.Output>().read(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$assignedTodos)
        }

        func index(req: Request) throws -> EventLoopFuture<CursorPage<Todo.Output>> {
            try RelatedResourceController<Todo.Output>().getCursorPage(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$assignedTodos,
                config: CursorPaginationConfig.defaultConfig)
        }
    }

    struct MyAssignedTodosForUserRelationController {
        func createRelation(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelationsController<Todo.Output>().createRelation(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$assignedTodos)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try RelationsController<Todo.Output>().deleteRelation(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \User.$assignedTodos)
        }
    }

}
