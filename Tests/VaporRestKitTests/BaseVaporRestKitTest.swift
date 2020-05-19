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

        }




    }
}
