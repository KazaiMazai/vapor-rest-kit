//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 20.05.2020.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent
import FluentSQLiteDriver


class BaseVaporRestKitTodosTest: XCTestCase {
    var app: Application!

    override func setUp() {
        app = Application(.testing)

        // Setup database
        app.databases.use(.sqlite(.memory), as: .sqlite)
        app.migrations.add(User.createInitialMigration())
        app.migrations.add(Todo.createInitialMigration())
        app.migrations.add(Tag.createInitialMigration())
        app.migrations.add(Todo.Relations.MarkedTags.Through.createInitialMigration())
        app.migrations.add(Todo.Relations.Assignees.Through.createInitialMigration())
        try! app.autoMigrate().wait()
    }

    override func tearDown() {
        app.shutdown()
    }

    func seed() throws {
//        try Todo.seed(on: app.db)
//        try Tag.seed(on: app.db)
    }

    func routes() throws {

        ApiVersion.allCases.forEach { version in
            let versiondGroup = app.grouped(version.path)

            TodoControllers.TodoController().setupAPIMethods(on: versiondGroup, for: "todos", with: version)
            UserControllers.UsersController().setupAPIMethods(on: versiondGroup, for: "users", with: version)
            TagControllers.TagController().setupAPIMethods(on: versiondGroup, for: "tags", with: version)


            let todosGroup = versiondGroup.grouped("todos")
            UserControllers.UsersForTodoController().setupAPIMethods(on: todosGroup, for: "users", with: version)
            UserControllers.TodoAssigneesRelationController().setupAPIMethods(on: todosGroup, for: "users", with: version)
            TagControllers.TagsForTodoController().setupAPIMethods(on: todosGroup, for: "tags", with: version)

            let usersGroup = versiondGroup.grouped("users")
            TodoControllers.AssignedTodosForUserController().setupAPIMethods(on: usersGroup, for: "todos", with: version)
            TodoControllers.TodosForUserController().setupAPIMethods(on: usersGroup, for: "todos", with: version)

            let authUsersGroup = usersGroup.grouped(MockAuthenticator<User>(userId: 1), User.guardMiddleware())
            TodoControllers.MyTodosController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)


            let tagsGroup = versiondGroup.grouped("tags")
            TodoControllers.TodosForTagsController().setupAPIMethods(on: tagsGroup, for: "todos", with: version)
            TodoControllers.TodosForTagsRelationController().setupAPIMethods(on: tagsGroup, for: "todos", with: version)
        }
    }
}
