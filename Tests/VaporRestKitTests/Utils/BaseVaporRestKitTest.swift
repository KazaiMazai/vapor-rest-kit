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

    override func setUpWithError() throws {
        app = Application(.testing)

        // Setup database
        app.databases.use(.sqlite(.memory), as: .sqlite)
        app.migrations.add(StarTag.createInitialMigration())
        app.migrations.add(Galaxy.createInitialMigration())
        app.migrations.add(Star.createInitialMigration())
        app.migrations.add(Star.Relations.MarkedTags.Through.createInitialMigration())
        app.migrations.add(Planet.createInitialMigration())

        app.migrations.add(ReferralCode.createInitialMigration())
        app.migrations.add(User.createInitialMigration())
        app.migrations.add(Todo.createInitialMigration())
        app.migrations.add(Tag.createInitialMigration())
        app.migrations.add(Todo.Relations.MarkedTags.Through.createInitialMigration())
        app.migrations.add(Todo.Relations.Assignees.Through.createInitialMigration())
        try app.autoMigrate().wait()
    }

    override func tearDown() {
        app.shutdown()
    }

    func seed() throws {
        try Star.seed(on: app.db)
        try Galaxy.seed(on: app.db)
    }
}


