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
        app.migrations.add(Planet.createInitialMigration())

        app.migrations.add(ReferralCode.createInitialMigration())
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
        try Galaxy.seed(on: app.db)
    }

    func routes() throws {
        ApiVersion.allCases.forEach { version in
            let versiondGroup = app.grouped(version.path)

            versiondGroup.on(
                .POST,
                [Galaxy.path, Galaxy.idPath, "belongs", StarTag.path],
                use: { req -> EventLoopFuture<StarTag.Output> in

                    try ResourceController<StarTag>()
                        .create(req: req,
                                using: StarTag.Input.self)
                })

            StarTagControllers.StarTagController().setupAPIMethods(on: versiondGroup, for: "star_tags", with: version)

            StarControllers.StarController().setupAPIMethods(on: versiondGroup, for: "stars", with: version)
            StarControllers.ExtendableStarController().setupAPIMethods(on: versiondGroup, for: "ext_stars", with: version)
            StarControllers.FullStarController().setupAPIMethods(on: versiondGroup, for: "full_stars", with: version)
            StarControllers.DynamicStarController().setupAPIMethods(on: versiondGroup, for: "d_stars", with: version)

            GalaxyControllers.GalaxyController().setupAPIMethods(on: versiondGroup, for: "galaxies", with: version)

            let galaxyGroup = versiondGroup.grouped("galaxies")

            StarControllers.StarForGalaxyNestedController().setupAPIMethods(on: galaxyGroup, for: "stars", with: version)
            StarControllers.ExtendableStarForGalaxyNestedController().setupAPIMethods(on: galaxyGroup, for: "ext_stars", with: version)
            StarControllers.FullStarForGalaxyNestedController().setupAPIMethods(on: galaxyGroup, for: "full_stars", with: version)
            StarControllers.DynamicStarForGalaxyNestedController().setupAPIMethods(on: galaxyGroup, for: "d_stars", with: version)


            StarControllers.StarForGalaxyRelationNestedController().setupAPIMethods(on: galaxyGroup, for: "stars", with: version)

            let starTagGroup = versiondGroup.grouped("star_tags")

            StarControllers.StarForTagsNestedController().setupAPIMethods(on: starTagGroup, for: "stars", with: version)
            StarControllers.StarForTagsRelationNestedController().setupAPIMethods(on: starTagGroup, for: "stars", with: version)


            StarControllers.ExtendableStarForTagsNestedController().setupAPIMethods(on: starTagGroup, for: "ext_stars", with: version)
            StarControllers.FullStarForTagsNestedController().setupAPIMethods(on: starTagGroup, for: "full_stars", with: version)
            StarControllers.DynamicStarForTagsNestedController().setupAPIMethods(on: starTagGroup, for: "d_stars", with: version)

            let planetGroup = versiondGroup.grouped("planets")

            StarControllers.StarForPlanetNestedController().setupAPIMethods(on: planetGroup, for: "stars", with: version)

            let starGroup = versiondGroup.grouped("stars")

            GalaxyControllers.GalaxyForStarsNestedController().setupAPIMethods(on: starGroup, for: "galaxies", with: version)
            GalaxyControllers.GalaxyForStarsRelationNestedController().setupAPIMethods(on: starGroup, for: "galaxies", with: version)

            GalaxyControllers.ExtendableGalaxyForStarsNestedController().setupAPIMethods(on: starGroup, for: "ext_galaxies", with: version)


            StarTagControllers.StarTagForStarNestedController().setupAPIMethods(on: starGroup, for: "star_tags", with: version)
            StarTagControllers.StarTagForStarRelationNestedController().setupAPIMethods(on: starGroup, for: "star_tags", with: version)

            TodoControllers.TodoController().setupAPIMethods(on: versiondGroup, for: "todos", with: version)
            UserControllers.UsersController().setupAPIMethods(on: versiondGroup, for: "users", with: version)
            TagControllers.TagController().setupAPIMethods(on: versiondGroup, for: "tags", with: version)
            ReferralCodeControllers.ReferralCodeController().setupAPIMethods(on: versiondGroup, for: "referral_codes", with: version)

            let todosGroup = versiondGroup.grouped("todos")
            let authTodosGroup = todosGroup.grouped(MockAuthenticator<User>(userId: 1), User.guardMiddleware())
            UserControllers.UsersForTodoController().setupAPIMethods(on: todosGroup, for: "users", with: version)
            UserControllers.TodoAssigneesRelationController().setupAPIMethods(on: authTodosGroup, for: "users", with: version)
            TagControllers.TagsForTodoController().setupAPIMethods(on: todosGroup, for: "tags", with: version)

            let usersGroup = versiondGroup.grouped("users")
            TodoControllers.AssignedTodosForUserController().setupAPIMethods(on: usersGroup, for: "todos", with: version)



            TodoControllers.TodosForUserController().setupAPIMethods(on: usersGroup, for: "todos", with: version)

            let authUsersGroup = usersGroup.grouped(MockAuthenticator<User>(userId: 1), User.guardMiddleware())

            TodoControllers.MyTodosController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            TodoControllers.MyTodosRelationController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            TodoControllers.MyAssignedTodosForUserController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            TodoControllers.MyAssignedTodosForUserRelationController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            ReferralCodeControllers.ReferralCodeForUserController().setupAPIMethods(on: authUsersGroup, for: "referral_codes", with: version)
            ReferralCodeControllers.ReferralCodeForUserRelationController().setupAPIMethods(on: authUsersGroup, for: "referral_codes", with: version)



            let tagsGroup = versiondGroup.grouped("tags")
            TodoControllers.TodosForTagsController().setupAPIMethods(on: tagsGroup, for: "todos", with: version)
            TodoControllers.TodosForTagsRelationController().setupAPIMethods(on: tagsGroup, for: "todos", with: version)
        }
    }

    func routesV2() throws {
        ApiVersion.allCases.forEach { version in
            let versiondGroup = app.grouped(version.path)

            versiondGroup.on(
                .POST,
                [StarTag.path],
                use: { req -> EventLoopFuture<StarTag.Output> in
                    try ResourceController<StarTag>().create(
                        req: req,
                        using: StarTag.Input.self)
                }
            )



            versiondGroup
                .grouped("stars")
                .with(StarControllersV2.StarController()) { route, controller in

                route.on(.POST, use: controller.create)
                route.on(.GET, Star.idPath, use: controller.read)
                route.on(.PUT, Star.idPath, use: controller.update)
                route.on(.PATCH, Star.idPath, use: controller.patch)
                route.on(.DELETE, Star.idPath, use: controller.delete)
                route.on(.GET, use: controller.index)
            }

            versiondGroup
                .grouped("ext_stars")
                .with(StarControllersV2.ExtendableStarController()) { route, controller in

                route.on(.POST, use: controller.create)
                route.on(.GET, Star.idPath, use: controller.read)
                route.on(.PUT, Star.idPath, use: controller.update)
                route.on(.PATCH, Star.idPath, use: controller.patch)
                route.on(.DELETE, Star.idPath, use: controller.delete)
                route.on(.GET, use: controller.index)
            }
            versiondGroup
                .grouped("full_stars")
                .with(StarControllersV2.FullStarController()) { route, controller in

                route.on(.POST, use: controller.create)
                route.on(.GET, Star.idPath, use: controller.read)
                route.on(.PUT, Star.idPath, use: controller.update)
                route.on(.PATCH, Star.idPath, use: controller.patch)
                route.on(.DELETE, Star.idPath, use: controller.delete)
                route.on(.GET, use: controller.index)
            }

            versiondGroup
                .grouped("d_stars")
                .with(StarControllersV2.DynamicStarController()) { route, controller in

                route.on(.POST, use: controller.create)
                route.on(.GET, Star.idPath, use: controller.read)
                route.on(.PUT, Star.idPath, use: controller.update)
                route.on(.PATCH, Star.idPath, use: controller.patch)
                route.on(.DELETE, Star.idPath, use: controller.delete)
                route.on(.GET, use: controller.index)
            }

            versiondGroup
                .grouped("galaxies")
                .with(GalaxyControllersV2.GalaxyController()) { route, controller in

                    route.on(.POST, use: controller.create)
                    route.on(.GET, Galaxy.idPath, use: controller.read)
                    route.on(.PUT, Galaxy.idPath, use: controller.update)
                    route.on(.PATCH, Galaxy.idPath, use: controller.patch)
                    route.on(.DELETE, Galaxy.idPath, use: controller.delete)
                    route.on(.GET, use: controller.index)
                }
                .with(StarControllersV2.StarForGalaxyNestedController()) { route, controller in

                    route.on(.POST, Galaxy.idPath, "contains", "stars", use: controller.create)
                    route.on(.GET, Galaxy.idPath, "contains", "stars", Star.idPath, use: controller.read)
                    route.on(.PUT, Galaxy.idPath, "contains", "stars", Star.idPath, use: controller.update)
                    route.on(.PATCH, Galaxy.idPath, "contains", "stars", Star.idPath, use: controller.patch)
                    route.on(.DELETE, Galaxy.idPath, "contains", "stars", Star.idPath, use: controller.delete)
                    route.on(.GET, Galaxy.idPath, "contains", "stars", use: controller.index)
                }
                .with(StarControllersV2.ExtendableStarForGalaxyNestedController()) { route, controller in

                    route.on(.POST, Galaxy.idPath, "contains", "ext_stars", use: controller.create)
                    route.on(.GET, Galaxy.idPath, "contains", "ext_stars", Star.idPath, use: controller.read)
                    route.on(.PUT, Galaxy.idPath, "contains", "ext_stars", Star.idPath, use: controller.update)
                    route.on(.PATCH, Galaxy.idPath, "contains", "ext_stars", Star.idPath, use: controller.patch)
                    route.on(.DELETE, Galaxy.idPath, "contains", "ext_stars", Star.idPath, use: controller.delete)
                    route.on(.GET, Galaxy.idPath, "contains", "ext_stars", use: controller.index)
                }
                .with(StarControllersV2.FullStarForGalaxyNestedController()) { route, controller in

                    route.on(.POST, Galaxy.idPath, "contains", "full_stars", use: controller.create)
                    route.on(.GET, Galaxy.idPath, "contains", "full_stars", Star.idPath, use: controller.read)
                    route.on(.PUT, Galaxy.idPath, "contains", "full_stars", Star.idPath, use: controller.update)
                    route.on(.PATCH, Galaxy.idPath, "contains", "full_stars", Star.idPath, use: controller.patch)
                    route.on(.DELETE, Galaxy.idPath, "contains", "full_stars", Star.idPath, use: controller.delete)
                    route.on(.GET, Galaxy.idPath, "contains", "full_stars", use: controller.index)
                }
                .with(StarControllersV2.DynamicStarForGalaxyNestedController()) { route, controller in

                    route.on(.POST, Galaxy.idPath, "contains", "d_stars", use: controller.create)
                    route.on(.GET, Galaxy.idPath, "contains", "d_stars", Star.idPath, use: controller.read)
                    route.on(.PUT, Galaxy.idPath, "contains", "d_stars", Star.idPath, use: controller.update)
                    route.on(.PATCH, Galaxy.idPath, "contains", "d_stars", Star.idPath, use: controller.patch)
                    route.on(.DELETE, Galaxy.idPath, "contains", "d_stars", Star.idPath, use: controller.delete)
                    route.on(.GET, Galaxy.idPath, "contains", "d_stars", use: controller.index)
                }
                .with(StarControllersV2.StarForGalaxyRelationNestedController()) { route, controller in

                    route.on(.POST, Galaxy.idPath, "contains", "stars", Star.idPath, "relation", use: controller.createRelation)
                    route.on(.DELETE, Galaxy.idPath, "contains", "stars", Star.idPath, "relation", use: controller.deleteRelation)
                }


            let galaxyGroup = versiondGroup.grouped("galaxies")

            let starTagGroup = versiondGroup.grouped("star_tags")

            versiondGroup
                .grouped("star_tags")
                .with(StarTagControllersV2.StarTagController()) { route, controller in

                    route.on(.POST, use: controller.create)
                    route.on(.GET, StarTag.idPath, use: controller.read)
                    route.on(.PUT, StarTag.idPath, use: controller.update)
                    route.on(.PATCH, StarTag.idPath, use: controller.patch)
                    route.on(.DELETE, StarTag.idPath, use: controller.delete)
                    route.on(.GET, use: controller.index)
                }
                .with(StarControllersV2.StarForTagsNestedController()) { route, controller in

                    route.on(.POST, StarTag.idPath, "related", "stars", use: controller.create)
                    route.on(.GET, StarTag.idPath, "related", "stars", Star.idPath, use: controller.read)
                    route.on(.PUT, StarTag.idPath, "related", "stars", Star.idPath, use: controller.update)
                    route.on(.PATCH, StarTag.idPath, "related", "stars", Star.idPath, use: controller.patch)
                    route.on(.DELETE, StarTag.idPath, "related", "stars", Star.idPath, use: controller.delete)
                    route.on(.GET, StarTag.idPath, "related", "stars", use: controller.index)
                }
                .with(StarControllersV2.StarForTagsRelationNestedController()) { route, controller in

                    route.on(.POST, StarTag.idPath, "related", "stars", Star.idPath, "relation", use: controller.createRelation)
                    route.on(.DELETE, StarTag.idPath, "related", "stars", Star.idPath, "relation", use: controller.deleteRelation)
                }
                .with(StarControllersV2.ExtendableStarForTagsNestedController()) { route, controller in

                    route.on(.POST, StarTag.idPath, "related", "ext_stars", use: controller.create)
                    route.on(.GET, StarTag.idPath, "related", "ext_stars", Star.idPath, use: controller.read)
                    route.on(.PUT, StarTag.idPath, "related", "ext_stars", Star.idPath, use: controller.update)
                    route.on(.PATCH, StarTag.idPath, "related", "ext_stars", Star.idPath, use: controller.patch)
                    route.on(.DELETE, StarTag.idPath, "related", "ext_stars", Star.idPath, use: controller.delete)
                    route.on(.GET, StarTag.idPath, "related", "ext_stars", use: controller.index)
                }
                .with(StarControllersV2.FullStarForTagsNestedController()) { route, controller in

                    route.on(.POST, StarTag.idPath, "related", "full_stars", use: controller.create)
                    route.on(.GET, StarTag.idPath, "related", "full_stars", Star.idPath, use: controller.read)
                    route.on(.PUT, StarTag.idPath, "related", "full_stars", Star.idPath, use: controller.update)
                    route.on(.PATCH, StarTag.idPath, "related", "full_stars", Star.idPath, use: controller.patch)
                    route.on(.DELETE, StarTag.idPath, "related", "full_stars", Star.idPath, use: controller.delete)
                    route.on(.GET, StarTag.idPath, "related", "full_stars", use: controller.index)
                }
                .with(StarControllersV2.DynamicStarForTagsNestedController()) { route, controller in

                    route.on(.POST, StarTag.idPath, "related", "d_stars", use: controller.create)
                    route.on(.GET, StarTag.idPath, "related", "d_stars", Star.idPath, use: controller.read)
                    route.on(.PUT, StarTag.idPath, "related", "d_stars", Star.idPath, use: controller.update)
                    route.on(.PATCH, StarTag.idPath, "related", "d_stars", Star.idPath, use: controller.patch)
                    route.on(.DELETE, StarTag.idPath, "related", "d_stars", Star.idPath, use: controller.delete)
                    route.on(.GET, StarTag.idPath, "related", "d_stars", use: controller.index)
                }


            let planetGroup = versiondGroup.grouped("planets")

            versiondGroup
                .grouped("planets")
                .with(StarControllersV2.StarForPlanetNestedController()) { route, controller in

                    route.on(.POST, Planet.idPath, "refers", "stars", use: controller.create)
                    route.on(.GET, Planet.idPath, "refers", "stars", Star.idPath, use: controller.read)
                    route.on(.PUT, Planet.idPath, "refers", "stars", Star.idPath, use: controller.update)
                    route.on(.PATCH, Planet.idPath, "refers", "stars", Star.idPath, use: controller.patch)
                    route.on(.DELETE, Planet.idPath, "refers", "stars", Star.idPath, use: controller.delete)
                    route.on(.GET, Planet.idPath, "refers", "stars", use: controller.index)
                }


            let starGroup = versiondGroup.grouped("stars")

            GalaxyControllers.GalaxyForStarsNestedController().setupAPIMethods(on: starGroup, for: "galaxies", with: version)
            GalaxyControllers.GalaxyForStarsRelationNestedController().setupAPIMethods(on: starGroup, for: "galaxies", with: version)

            GalaxyControllers.ExtendableGalaxyForStarsNestedController().setupAPIMethods(on: starGroup, for: "ext_galaxies", with: version)


            StarTagControllers.StarTagForStarNestedController().setupAPIMethods(on: starGroup, for: "star_tags", with: version)
            StarTagControllers.StarTagForStarRelationNestedController().setupAPIMethods(on: starGroup, for: "star_tags", with: version)

            TodoControllers.TodoController().setupAPIMethods(on: versiondGroup, for: "todos", with: version)
            UserControllers.UsersController().setupAPIMethods(on: versiondGroup, for: "users", with: version)
            TagControllers.TagController().setupAPIMethods(on: versiondGroup, for: "tags", with: version)
            ReferralCodeControllers.ReferralCodeController().setupAPIMethods(on: versiondGroup, for: "referral_codes", with: version)

            let todosGroup = versiondGroup.grouped("todos")
            let authTodosGroup = todosGroup.grouped(MockAuthenticator<User>(userId: 1), User.guardMiddleware())
            UserControllers.UsersForTodoController().setupAPIMethods(on: todosGroup, for: "users", with: version)
            UserControllers.TodoAssigneesRelationController().setupAPIMethods(on: authTodosGroup, for: "users", with: version)
            TagControllers.TagsForTodoController().setupAPIMethods(on: todosGroup, for: "tags", with: version)

            let usersGroup = versiondGroup.grouped("users")
            TodoControllers.AssignedTodosForUserController().setupAPIMethods(on: usersGroup, for: "todos", with: version)



            TodoControllers.TodosForUserController().setupAPIMethods(on: usersGroup, for: "todos", with: version)

            let authUsersGroup = usersGroup.grouped(MockAuthenticator<User>(userId: 1), User.guardMiddleware())

            TodoControllers.MyTodosController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            TodoControllers.MyTodosRelationController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            TodoControllers.MyAssignedTodosForUserController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            TodoControllers.MyAssignedTodosForUserRelationController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            ReferralCodeControllers.ReferralCodeForUserController().setupAPIMethods(on: authUsersGroup, for: "referral_codes", with: version)
            ReferralCodeControllers.ReferralCodeForUserRelationController().setupAPIMethods(on: authUsersGroup, for: "referral_codes", with: version)



            let tagsGroup = versiondGroup.grouped("tags")
            TodoControllers.TodosForTagsController().setupAPIMethods(on: tagsGroup, for: "todos", with: version)
            TodoControllers.TodosForTagsRelationController().setupAPIMethods(on: tagsGroup, for: "todos", with: version)
        }
    }
}
