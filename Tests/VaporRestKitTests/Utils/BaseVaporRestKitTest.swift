//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent
import FluentSQLiteDriver


class BaseVaporRestKitTest: XCTestCase {
    var app: Application!

    override func setUp() {
        app = Application(.testing)

        // Setup database
        app.databases.use(.sqlite(.memory), as: .sqlite)
        app.migrations.add(StarTag.createInitialMigration())
        app.migrations.add(Galaxy.createInitialMigration())
        app.migrations.add(Star.createInitialMigration())
        app.migrations.add(Star.Relations.MarkedTags.Through.createInitialMigration())

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
        try Star.seed(on: app.db)
    }

    func routes() throws {
        ApiVersion.allCases.forEach { version in
            let versiondGroup = app.grouped(version.path)

            StarTagControllers.StarTagController().setupAPIMethods(on: versiondGroup, for: "star_tags", with: version)
            StarControllers.StarController().setupAPIMethods(on: versiondGroup, for: "stars", with: version)
            GalaxyControllers.GalaxyController().setupAPIMethods(on: versiondGroup, for: "galaxies", with: version)

            let galaxyGroup = versiondGroup.grouped("galaxies")

            StarControllers.StarForGalaxyNestedController().setupAPIMethods(on: galaxyGroup, for: "stars", with: version)
            StarControllers.StarForGalaxyRelationNestedController().setupAPIMethods(on: galaxyGroup, for: "stars", with: version)

            let starTagGroup = versiondGroup.grouped("star_tags")

            StarControllers.StarForTagsNestedController().setupAPIMethods(on: starTagGroup, for: "stars", with: version)
            StarControllers.StarForTagsRelationNestedController().setupAPIMethods(on: starTagGroup, for: "stars", with: version)

            let starGroup = versiondGroup.grouped("stars")

            GalaxyControllers.GalaxyForStarsNestedController().setupAPIMethods(on: starGroup, for: "galaxies", with: version)
            GalaxyControllers.GalaxyForStarsRelationNestedController().setupAPIMethods(on: starGroup, for: "galaxies", with: version)

            StarTagControllers.StarTagForStarNestedController().setupAPIMethods(on: starGroup, for: "star_tags", with: version)
            StarTagControllers.StarTagForStarRelationNestedController().setupAPIMethods(on: starGroup, for: "star_tags", with: version)

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
